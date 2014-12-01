package ru.kutu.osmf.subtitles.loader {

	import ru.kutu.osmf.subtitles.*;
	
	import org.osmf.media.MediaResourceBase;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.LoaderBase;

	import ru.kutu.osmf.subtitles.model.SubtitlesVO;

	public class SubtitlesLoadTrait extends LoadTrait {
		
		public var index:uint;
		public var subtitlesVO:SubtitlesVO;
		
		public function SubtitlesLoadTrait(loader:LoaderBase, resource:MediaResourceBase) {
			super(loader, resource);
		}
		
		override public function unload():void {
			subtitlesVO = null;
			super.unload();
		}
		
	}
	
}
