package {

	import ru.kutu.osmf.subtitles.*;

	import ru.kutu.osmf.subtitles.*;
	
	import flash.display.Sprite;
	
	import org.osmf.media.PluginInfo;
	
	public class SubtitlesDynamicPlugin extends Sprite
	{
		private var _pluginInfo:PluginInfo;
		
		public function SubtitlesDynamicPlugin()
		{
			_pluginInfo = new SubtitlesPluginInfo();
		}
		
		public function get pluginInfo():PluginInfo
		{
			return _pluginInfo;
		}
		
	}
	
}
