#Copyright (c) 2011 David Keegan
#
#Permission is hereby granted, free of charge, to any person obtaining a copy
#of this software and associated documentation files (the "Software"), to deal
#in the Software without restriction, including without limitation the rights
#to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#copies of the Software, and to permit persons to whom the Software is
#furnished to do so, subject to the following conditions:
#
#The above copyright notice and this permission notice shall be included in
#all copies or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#THE SOFTWARE.
#
#https://github.com/InScopeApps/SparkleMotion
#

__all__ = (
    'GetAppInfoData',
    'GetAppShortStringVersion',
    'GetDsaSignature',
    'ZipDir',
    'SparkleMotion',
)

import os
import zipfile
import subprocess
import plistlib
import time
from datetime import datetime
import urllib

def GetAppInfoData(appPath):
    '''Get the value of CFBundleVersion or 0'''
    infoPlist = os.path.join(appPath, 'Contents', 'Info.plist')
    return plistlib.readPlist(infoPlist)

def GetAppShortStringVersion(appPath):
    '''Get the value of CFBundleShortVersionString or None'''
    data = GetAppInfoData(appPath)
    return data.get('CFBundleShortVersionString')

def GetDsaSignature(zipFile, privPem):
    '''Uses the sign_update.rb script to generate the dsa signature'''
    commandAndArgs = 'openssl dgst -sha1 -binary < "%s" | openssl dgst -dss1 -sign "%s" | openssl enc -base64' % (zipFile, privPem)
    proc = subprocess.Popen(commandAndArgs, shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
    stdout, stderr = proc.communicate()
    if stderr:
        raise RuntimeError(stderr)
    return stdout.strip()
    
def ZipDir(inputDir, outputZip):
    '''Zip up a directory and preserve symlinks and empty directories'''
    zipOut = zipfile.ZipFile(outputZip, 'w', compression=zipfile.ZIP_DEFLATED)
    
    rootLen = len(os.path.dirname(inputDir))
    def _ArchiveDirectory(parentDirectory):
        contents = os.listdir(parentDirectory)
        #store empty directories
        if not contents:
            #http://www.velocityreviews.com/forums/t318840-add-empty-directory-using-zipfile.html
            archiveRoot = parentDirectory[rootLen:].replace('\\', '/').lstrip('/')
            zipInfo = zipfile.ZipInfo(archiveRoot+'/')
            zipOut.writestr(zipInfo, '')
        for item in contents:
            fullPath = os.path.join(parentDirectory, item)
            if os.path.isdir(fullPath) and not os.path.islink(fullPath):
                _ArchiveDirectory(fullPath)
            else:
                archiveRoot = fullPath[rootLen:].replace('\\', '/').lstrip('/')
                if os.path.islink(fullPath):
                    # http://www.mail-archive.com/python-list@python.org/msg34223.html
                    zipInfo = zipfile.ZipInfo(archiveRoot)
                    zipInfo.create_system = 3
                    # long type of hex val of '0xA1ED0000L',
                    # say, symlink attr magic...
                    zipInfo.external_attr = 2716663808L
                    zipOut.writestr(zipInfo, os.readlink(fullPath))
                else:
                    zipOut.write(fullPath, archiveRoot, zipfile.ZIP_DEFLATED)
    _ArchiveDirectory(inputDir)
    
    zipOut.close()

class SparkleMotion(object):
    #required
    appPath = None
    privPemPath = None
    urlRoot = None
    appCastFileName = None
    stagingAreaPath = None
    zipUrlRoot = None
    
    def zipFileName(self):
        '''Specity the formatting of the zip file'''
        return '%s-%s.zip' % (self.appName(), self.version())
    
    def appCastTitle(self):
        '''Specity the title of the appcast'''
        return '%s Updates' % self.appName()
        
    def appCastDescription(self):
        '''Specity the discription of the appcast'''
        return 'AppCast updates for %s' % self.appName()
    
    def updateTitle(self):
        '''Specify the formatting of the item's title'''
        if self.shortVersionString() is None:
            return '%s Version %s' % (self.appName(), self.version())
        else:
            return '%s Version %s - Build %s' % (self.appName(), self.shortVersionString(), self.version())
            
    def releaseNotesFileName(self):
        '''Specify the formatting of the item's release notes url'''
        return '%s.html' % self.version()
    
    def defaultNote(self):
        '''The default release note to be used in the placeholder release file'''
        return '''
		<br>
		<table class="dots" width="100%" border="0" cellspacing="0" cellpadding="0" summary="Two column table with heading">
			<tr>
				<td class="blue" colspan="2">
					<h3>NEW THING.</h3>
				</td>
			</tr>
			<tr>
				<td valign="top" width="150"><img src="someimage.png" alt="THIS IS MY NEW SOMETHING"  width="150" border="0"></td>
				<td valign="top">
					<p>Fusce lorem risus, eleifend et, gravida a, consectetuer venenatis, neque. In hac habitasse platea dictumst. 
					Etiam scelerisque tempus nulla. Mauris vitae pede in mi luctus accumsan. Suspendisse potenti. Sed at pede. 
					Quisque luctus. Nullam diam velit, ultrices quis, sodales vitae, iaculis sit amet, neque. 
					Nam ut diam. Donec consectetuer. Nulla a sapien.</p>
				</td>
			</tr>
		</table>
		<br>
	   '''
    
    #class methods - these can be called but shouldn't be subclassed
    def __init__(self):
        if not self.appPath or not os.path.isdir(self.appPath):
            raise IOError('appPath is not valid: %s' % self.appPath)
            
        if not self.privPemPath or not os.path.isfile(self.privPemPath):
            raise IOError('privPemPath is not valid: %s' % self.privPemPath)
            
        if not self.urlRoot:
            raise IOError('urlRoot is not valid: %s' % self.urlRoot)
            
        if not self.stagingAreaPath:
            raise IOError('stagingAreaPath is not valid: %s' % self.stagingAreaPath)
            
        if not self.appCastFileName:
            raise IOError('appCastFileName is not valid: %s' % self.appCastFileName)
        
        if not self.zipUrlRoot:
            self.zipUrlRoot = self.urlRoot
        
        self.__appInfo = GetAppInfoData(self.appPath)
            
        self.__appName = os.path.splitext(os.path.basename(self.appPath))[0]
        self.__appCastPath = os.path.join(self.stagingAreaPath, self.appCastFileName)
        
        if not os.path.isdir(self.stagingAreaPath):
            os.makedirs(self.stagingAreaPath)
        self.__zipFile = os.path.join(self.stagingAreaPath, self.zipFileName())
        
    def version(self):
        '''Get the value of CFBundleVersion or 0'''
        return self.__appInfo.get('CFBundleVersion', 0)
        
    def shortVersionString(self):
        '''Get the value of CFBundleShortVersionString or None'''
        return self.__appInfo.get('CFBundleShortVersionString')
    
    def zipPath(self):
        '''Get the path of the zip file'''
        return self.__zipFile
        
    def appName(self):
        '''Get the name of the application'''
        return self.__appName
    
    def appCastPath(self):
        '''Get the full path to the appcast file'''
        return self.__appCastPath
    
    def getItem(self):
        '''Get the item block for the appcast'''
        dsaSignature =  GetDsaSignature(self.zipPath(), self.privPemPath)
        
        items = []
        
        #title
        items.append('<title>%s</title>' % self.updateTitle())
        
        #sparkle:releaseNotesLink
        items.append('<sparkle:releaseNotesLink>%s</sparkle:releaseNotesLink>' % os.path.join(self.urlRoot, self.releaseNotesFileName()))
        
        #pubDate
        date = datetime.now()
        timezone = "%+4.4d" % (time.timezone / -(60*60) * 100)
        pubDate = date.strftime('%a, %%02d %b %G %X %%s') % (date.day, timezone)
        items.append('<pubDate>%s</pubDate>' % pubDate)
        
        #enclosure
        items.append('<enclosure url="%s"' % os.path.join(self.zipUrlRoot, urllib.quote(os.path.basename(self.zipPath()))))
        items.append('\tsparkle:version="%s"' % self.version())
        if self.shortVersionString() is not None:
            items.append('\tsparkle:shortVersionString="%s"' % self.shortVersionString())
        items.append('\tsparkle:dsaSignature="%s"' % dsaSignature)
        items.append('\tlength="%s"' % os.path.getsize(self.zipPath()))
        items.append('\ttype="application/octet-stream"/>')
        
        return '\n\t\t<item>\n\t\t\t%s\n\t\t</item>\n\n' % '\n\t\t\t'.join(items)
    
    def writeReleaseNotes(self):
        '''Write the placeholder release notes file unless it already exists'''
        releaseNotesFile = os.path.join(self.stagingAreaPath, self.releaseNotesFileName())
        if not os.path.isfile(releaseNotesFile):
            releaseNotes = open(releaseNotesFile, 'w')
            releaseNotes.write('<html>\n')
            
            releaseNotes.write('\t<head>\n')
            releaseNotes.write('\t\t<meta http-equiv="content-type" content="text/html;charset=utf-8">\n')
            releaseNotes.write('\t\t<title>%s</title>\n' % self.updateTitle())
            releaseNotes.write('\t\t<meta name="robots" content="anchors">\n')
            releaseNotes.write('\t\t<link href="rnotes.css" type="text/css" rel="stylesheet" media="all">\n')
            releaseNotes.write('\t</head>\n')
            releaseNotes.write('\t<body>\n')
            	
            releaseNotes.write(self.defaultNote())
            releaseNotes.write('\n')  
            
            releaseNotes.write('\t</body>\n')
            releaseNotes.write('</html>\n')
            releaseNotes.close()
            
    def writeAppCast(self):
        '''Write the appcast file'''
        appCast = open(self.__appCastPath, 'w')
        
        appCast.write('<?xml version="1.0" encoding="utf-8"?>\n')
        appCast.write('<rss version="2.0" xmlns:sparkle="http://www.andymatuschak.org/xml-namespaces/sparkle" xmlns:dc="http://purl.org/dc/elements/1.1/">\n')
        appCast.write('\t<channel>\n')
        appCast.write('\t\t<title>%s</title>\n' % self.appCastTitle())
        appCast.write('\t\t<link>%s</link>\n' % os.path.join(self.urlRoot, self.appCastFileName))
        appCast.write('\t\t<description>%s</description>\n' % self.appCastDescription())
        appCast.write('\t\t<language>en</language>\n')
              
        appCast.write(self.getItem())
                
        appCast.write('\t</channel>\n')
        appCast.write('</rss>\n')
        
        appCast.close()
           
    def run(self):
        '''Build the zip and write the release notes and appcast'''
        ZipDir(self.appPath, self.zipPath())
        self.writeReleaseNotes()
        self.writeAppCast()
        
        print 'Output version: %s' % self.version()
