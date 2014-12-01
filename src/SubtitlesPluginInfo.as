package {
	
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactoryItem;
	import org.osmf.media.MediaFactoryItemType;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.media.PluginInfo;
	import org.osmf.net.NetLoader;

	import ru.kutu.osmf.subtitles.elements.SubtitlesProxyElement;

	public class SubtitlesPluginInfo extends PluginInfo
	{
		// TODO: remove this. it's a poorly written plugin
		public static const NAMESPACE:String = "http://kutu.ru/osmf/plugins/subtitles";

		public function SubtitlesPluginInfo(items:Vector.<MediaFactoryItem> = null, elementCreatedNotification:Function = null)
		{
			items = new Vector.<MediaFactoryItem>();
			items.push(new MediaFactoryItem('SubtitlesDynamicPlugin', canHandleResource, createSubtitlesProxyElement, MediaFactoryItemType.PROXY));

			super(items, elementCreatedNotification);
		}

		override public function initializePlugin(resource : MediaResourceBase) : void
		{
			CONFIG::LOGGING
			{
				trace('initialize subtitles plugin');
			}

			if (resource == null) { return; }

			trace('[srt] initialize', resource);

			var metadataNamespaceURLs : Vector.<String> = resource.metadataNamespaceURLs;
			for each (var k:String in metadataNamespaceURLs)
			{
				trace('[srt] ', k);
			}
		}

		private function canHandleResource(resource:MediaResourceBase):Boolean
		{
			trace('[srt] canHandleResource', resource);
			trace('[srt] metadataNamespaceURLs', resource.metadataNamespaceURLs);
			// check resource info, find the src!

			return true;
//			return resource.metadataNamespaceURLs.indexOf('srt') != -1;
		}

		private function createSubtitlesProxyElement():MediaElement
		{
			trace('[srt] createSubtitlesProxyElement');
			return new SubtitlesProxyElement();
		}

//		public function SubtitlesPluginInfo() {
//			var items:Vector.<MediaFactoryItem> = new Vector.<MediaFactoryItem>();
//
//			var loader:NetLoader = new NetLoader();
//			items.push(new MediaFactoryItem("ru.kutu.osmf.subtitles.SubtitlesDynamicPlugin"
//				, function(resource:MediaResourceBase):Boolean {
//					return resource.metadataNamespaceURLs.indexOf(NAMESPACE) != -1;
//				}
//				, function():MediaElement {
//					return new SubtitlesProxyElement();
//				}
//				, MediaFactoryItemType.PROXY)
//			);
//
//			super(items);
//		}
		
	}
}
