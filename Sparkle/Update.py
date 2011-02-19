import os
from SparkleMotion import SparkleMotion

class Update(SparkleMotion):
    urlRoot = 'http://appcast.inscopeapps.com/CoachesLoupe'
    privPemPath = os.path.abspath('dsa_priv.pem')
    appCastFileName = 'Appcast.xml'
    appPath = os.path.abspath('Coaches Loupe.app')
    stagingAreaPath = os.path.abspath('Data')
    zipUrlRoot = 'https://github.com/downloads/InScopeApps/Coaches-Loupe'
    
    def zipFileName(self):
        return '%s-%s.zip' % (self.appName().replace(' ', ''), self.shortVersionString())
        
    def releaseNotesFileName(self):
        return '%s.html' % self.shortVersionString()
        
    def updateTitle(self):
        return 'Version %s' % self.shortVersionString()
        
    def defaultNote(self):
        return '''
        <ul>
	       <li>
	           <h1>Sweet new feature</h1>
	           <span>This new feature is going to rock!</span>
	       </li>
	   </ul>
	   '''    

Update().run()