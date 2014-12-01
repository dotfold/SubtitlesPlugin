package ru.kutu.osmf.subtitles.elements
{

	import org.osmf.events.MediaError;
	import org.osmf.events.MediaErrorEvent;
	import org.osmf.media.MediaResourceBase;
	import org.osmf.metadata.Metadata;

	import ru.kutu.osmf.subtitles.*;
	
	import by.blooddy.crypto.serialization.JSON;
	
	import org.osmf.elements.ProxyElement;
	import org.osmf.events.LoadEvent;
	import org.osmf.events.MediaElementEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.MediaTraitType;

	import ru.kutu.osmf.subtitles.model.SubtitlesSourceItem;
	import ru.kutu.osmf.subtitles.traits.SubtitlesTrait;

	CONFIG::LOGGING
	{
		import org.osmf.logging.Log;
		import org.osmf.logging.Logger;
	}
	
	public class SubtitlesProxyElement extends ProxyElement
	{

		/**
		 * Constant for the MediaError that is triggered when the proxiedElement
		 * is invalid (e.g. doesn't have the captioning metadata).
		 **/
		public static const MEDIA_ERROR_INVALID_PROXIED_ELEMENT:int = 2201;

		CONFIG::LOGGING
		{
			private static const logger:Logger = Log.getLogger("ru.kutu.osmf.subtitles.elements.SubtitlesProxyElement");
		}
		
		private var mediaLoadTrait:LoadTrait;
		private var subtitlesTrait:SubtitlesTrait;

		/**
		 * Constructor
		 * @param proxiedElement
		 */
		public function SubtitlesProxyElement(proxiedElement:MediaElement=null)
		{
			super(proxiedElement);
		}

		/**
		 *
		 * @param value
		 */
		override public function set proxiedElement(value:MediaElement):void
		{
			super.proxiedElement = value;

			CONFIG::LOGGING
			{
				logger.info('proxiedElement: {0}', value);
			}
			
			if (value == null) return;
			
			var mediaElement:MediaElement = super.proxiedElement;

			// Get the Timed Text url resource from the metadata of the element
			// that is wrapped.
			var tempResource:MediaResourceBase = (mediaElement && mediaElement.resource != null) ? mediaElement.resource : resource;
			if (tempResource == null)
			{
				trace('[srt] dispatch MediaErrorEvent.MEDIA_ERROR_INVALID_PROXIED_ELEMENT');
				dispatchEvent(new MediaErrorEvent( MediaErrorEvent.MEDIA_ERROR, false, false,
				                                   new MediaError(MEDIA_ERROR_INVALID_PROXIED_ELEMENT)));
			}
			else
			{
				var metadata:Metadata = tempResource.getMetadataValue('srt') as Metadata;
				if (metadata == null)
				{
					trace('no metadata found');
				}
				else
				{
					trace('[srt] getMetadataValue', metadata);
					var src:* = metadata.getValue('src');

					var sources:Vector.<SubtitlesSourceItem> = new Vector.<SubtitlesSourceItem>();
					sources.push(new SubtitlesSourceItem(src, 'English', 'en'));

					if (sources.length)
					{
						subtitlesTrait = new SubtitlesTrait(sources, mediaElement);
						mediaLoadTrait = mediaElement.getTrait(MediaTraitType.LOAD) as LoadTrait;
						if (mediaLoadTrait)
						{
							mediaLoadTrait.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onMediaLoadStateChange);
						}
						else
						{
							mediaElement.addEventListener(MediaElementEvent.TRAIT_ADD, onTraitAdd);
						}
						mediaElement.addEventListener(MediaElementEvent.TRAIT_REMOVE, onTraitRemove);
						checkReady();
					}
				}
			}
		}
		
		private function onMediaLoadStateChange(event:LoadEvent):void
		{
			checkReady();
		}
		
		private function onTraitAdd(event:MediaElementEvent):void
		{
			if (!mediaLoadTrait && event.traitType == MediaTraitType.LOAD)
			{
				mediaLoadTrait = super.proxiedElement.getTrait(MediaTraitType.LOAD) as LoadTrait;
				mediaLoadTrait.addEventListener(LoadEvent.LOAD_STATE_CHANGE, onMediaLoadStateChange);
				checkReady();
			}
		}
		
		private function onTraitRemove(event:MediaElementEvent):void
		{
			if (mediaLoadTrait && event.traitType == MediaTraitType.LOAD)
			{
				checkReady();
				if (mediaLoadTrait)
				{
					mediaLoadTrait.removeEventListener(LoadEvent.LOAD_STATE_CHANGE, onMediaLoadStateChange);
					mediaLoadTrait = null;
				}
			}
		}
		
		private function checkReady():void
		{
			if (!mediaLoadTrait || mediaLoadTrait.loadState != LoadState.READY)
			{
				return;
			}

			addTrait(SubtitlesTrait.SUBTITLES, subtitlesTrait);
			super.proxiedElement.removeEventListener(MediaElementEvent.TRAIT_ADD, onTraitAdd);
			super.proxiedElement.removeEventListener(MediaElementEvent.TRAIT_REMOVE, onTraitRemove);
			mediaLoadTrait.removeEventListener(LoadEvent.LOAD_STATE_CHANGE, onMediaLoadStateChange);
			mediaLoadTrait = null;
		}
		
	}
	
}
