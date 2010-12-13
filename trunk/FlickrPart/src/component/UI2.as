package component{
	import com.adobe.webapis.flickr.*;
	import com.adobe.webapis.flickr.FlickrService;
	import com.adobe.webapis.flickr.PagedPhotoList;
	import com.adobe.webapis.flickr.events.*;
	import com.adobe.webapis.flickr.events.FlickrResultEvent;
	import com.adobe.webapis.flickr.methodgroups.Photos;
	import com.adobe.webapis.flickr.methodgroups.Tags;
	
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.utils.setTimeout;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.effects.Move;
	import mx.effects.Parallel;
	import mx.effects.Zoom;
	import mx.graphics.SolidColor;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.primitives.Rect;
	
	
	public class UI2 extends spark.components.Group
	{
		protected var source:Array;
		//protected var image0:Image;
		protected var image0:UI3;
		protected var image1:UI3;
		protected var image2:UI3;
		protected var image3:UI3;
		protected var image4:UI3;
		protected var image5:UI3;
		protected var image6:UI3;
		protected var image7:UI3;
		protected var image8:UI3;
		
		protected var button_next:Button;
		protected var button_back:Button;
		protected var label:Label;
		
		//protected var testImage:Image;
		
		protected var photos:ArrayCollection;
		protected var photo_index:Array;
		protected var tag:String;
		
		protected var flickr:FlickrService;
		
		protected var start:int = 0;
		protected var end:int = 8;
		
		private var animation:Parallel; 
		//private var zoomFull:Parallel;
		private var zoomOriginalScale:Number = 0.2;
		
		private var background:Rect;
		
		override public function set width(value:Number):void {
			super.width = value;
			background.width = value;
		}
		
		override public function set height(value:Number):void {
			super.height = value;
			background.height = value;
		}
		
		public function UI2(){
			
			background = new Rect();
			background.width = this.width;
			background.height = this.height;
			var white:SolidColor = new SolidColor();
			white.color = 0xffffff;
			background.fill = white;
			this.addElement(background);
			
			animation = new Parallel();
			var zoom:Zoom = new Zoom();
			zoom.zoomWidthFrom = zoomOriginalScale;
			zoom.zoomWidthTo = zoomOriginalScale;
			zoom.zoomHeightFrom = zoomOriginalScale;
			zoom.zoomHeightTo = zoomOriginalScale;
			zoom.originX = 0;
			zoom.originY = 0;
			animation.addChild(zoom);
			
			//var background:Rect = new Rect();
			//background.width = this.width;
			//background.height = this.height;
			
			source = new Array();
			flickr = new FlickrService("f78be7ee768ee4e350e6155f9c0245a8");
			tag = new String();
			photo_index = new Array();
			//testImage = new Image;
			button_next = new Button();
			button_next.addEventListener(MouseEvent.CLICK,mouseClickOnNext);
			//this.addElement(button_next);
			button_back = new Button();
			button_back.addEventListener(MouseEvent.CLICK,mouseClickOnBack);
			//this.addElement(button_back);
			label = new Label();
			photos = new ArrayCollection();
			image0 = new UI3();//new Image();
			image0.visible = false;
			image0.addEventListener(MouseEvent.CLICK,mouseClickOn);
			this.addElement(image0);
			image1 = new UI3();
			image1.visible = false;
			image1.addEventListener(MouseEvent.CLICK,mouseClickOn);
			this.addElement(image1);
			image2 = new UI3();
			image2.visible = false;
			image2.addEventListener(MouseEvent.CLICK,mouseClickOn);
			this.addElement(image2);
			image3 = new UI3();
			image3.visible = false;
			image3.addEventListener(MouseEvent.CLICK,mouseClickOn);
			this.addElement(image3);
			image4 = new UI3();//Image();
			image4.visible = false;
			image4.addEventListener(MouseEvent.CLICK,mouseClickOn);
			this.addElement(image4);
			image5 = new UI3();
			image5.visible = false;
			image5.addEventListener(MouseEvent.CLICK,mouseClickOn);
			this.addElement(image5);
			image6 = new UI3();
			image6.visible = false;
			image6.addEventListener(MouseEvent.CLICK,mouseClickOn);
			this.addElement(image6);
			image7 = new UI3();
			image7.visible = false;
			image7.addEventListener(MouseEvent.CLICK,mouseClickOn);
			this.addElement(image7);
			image8 = new UI3();
			image8.visible = false;
			image8.addEventListener(MouseEvent.CLICK,mouseClickOn);
			this.addElement(image8);
			flickr.addEventListener(FlickrResultEvent.PHOTOS_SEARCH, photosSearchEventHandler);
			
		}
		
		public function set_tag(t:String):void{
			
			tag = t;
			flickr.photos.search("", tag, "any", "", null, null, null, null, -1, "date-posted-desc", -1, "", -1, -1, -1, "", "", "", "","", "", "", false, "", "", -1, -1, "", 100, 1);
			
			this.visible = true;
			this.includeInLayout = true;
		}
		
		public function photosSearchEventHandler(event:FlickrResultEvent):void {
			if(event.success){
				var photoList:PagedPhotoList = event.data.photos;
				photos = new ArrayCollection(photoList.photos);
				loadImages();
				//Alert.show("aa");
			}
			else{
				Alert.show("Flickr call failed. Did you update the API Key?");
			}
		}
		
		
		
		public function loadImages():void{
			var i: int = 0;
			for(i=0; i<photos.length; i++){
				var imageURL:String = 'http://static.flickr.com/' + photos[i].server + '/' + photos[i].id + '_' + photos[i].secret + '_m.jpg';
				source[i] = imageURL;
			}
			
			if(photos.length > 8){
				for(i=0;i<9;i++)photo_index[i]=i;
				label.text = (photo_index[0] + 1).toString() + " to " + (photo_index[8] + 1).toString() + " of " + photos.length.toString();
			} 
			else{
				for(i=0;i<photos.length;i++)photo_index[i]=i;
				label.text = (photo_index[0] + 1).toString() + " to " + (photo_index[photos.length - 1] + 1).toString() + " of " + photos.length.toString();
			}
			
			if(photos.length > 0){
				image0.x = 0 * 2 * this.width / 6 + this.width / 12;
				image0.y = 0 * 2 * this.height / 6 + this.height / 18;
				image0.width = this.width;// / 6;
				image0.height = this.height;// / 6;
				// image0.source = source[0];
				//image0.setim
				//image0.setImageUrl(source[0]);
				animation.play([image0]);
				image0.photo = photos[photo_index[0]];
			}
			
			if(photos.length > 1){
				image1.x = 1 * 2 * this.width / 6 + this.width / 12;
				image1.y = 0 * 2 * this.height / 6 + this.height / 18;
				image1.width = this.width;
				image1.height = this.height;
				//image1.source = source[1];
				animation.play([image1]);
				image1.photo = photos[photo_index[1]];
			}
			
			if(photos.length > 2){
				image2.x = 2 * 2 * this.width / 6 + this.width / 12;
				image2.y = 0 * 2 * this.height / 6 + this.height / 18;
				image2.width = this.width;
				image2.height = this.height;
				animation.play([image2]);
				image2.photo = photos[photo_index[2]];
			}
			
			if(photos.length > 3){
				image3.x = 0 * 2 * this.width / 6 + this.width / 12;
				image3.y = 1 * 2 * this.height / 6 + this.height / 18;
				image3.width = this.width;
				image3.height = this.height;
				animation.play([image3]);
				image3.photo = photos[photo_index[3]];
			}
			
			if(photos.length > 4){
				image4.x = 1 * 2 * this.width / 6 + this.width / 12;
				image4.y = 1 * 2 * this.height / 6 + this.height / 18;
				image4.width = this.width;//6;
				image4.height = this.height;// / 6;
				//image4.source = source[4];
				animation.play([image4]);
				image4.photo = photos[photo_index[4]];
			}
			
			if(photos.length > 5){
				image5.x = 2 * 2 * this.width / 6 + this.width / 12;
				image5.y = 1 * 2 * this.height / 6 + this.height / 18;
				image5.width = this.width ;
				image5.height = this.height ;
				animation.play([image5]);
				image5.photo = photos[photo_index[5]];
			}
			
			if(photos.length > 6){
				image6.x = 0 * 2 * this.width / 6 + this.width / 12;
				image6.y = 2 * 2 * this.height / 6 + this.height / 18;
				image6.width = this.width ;
				image6.height = this.height ;
				animation.play([image6]);
				image6.photo = photos[photo_index[6]];
			}
			
			if(photos.length > 7){
				image7.x = 1 * 2 * this.width / 6 + this.width / 12;
				image7.y = 2 * 2 * this.height / 6 + this.height / 18;
				image7.width = this.width ;
				image7.height = this.height ;
				animation.play([image7]);
				image7.photo = photos[photo_index[7]];
			}
			
			if(photos.length > 8){
				image8.x = 2 * 2 * this.width / 6 + this.width / 12;
				image8.y = 2 * 2 * this.height / 6 + this.height / 18;
				image8.width = this.width ;
				image8.height = this.height ;
				animation.play([image8]);
				image8.photo = photos[photo_index[8]];
			}
			
			
			
			//button_back.x = this.x + 0 * 2 * this.width / 6 + this.width / 12;
			//button_back.y = this.y + 5 * this.height / 6 + this.height / 18 + this.height / 36;
			//button_back.width = this.width / 12;
			//button_back.height = this.height / 18;
			button_back.x = 0.125 * this.width / 6;
			button_back.y = 2.5 * this.height / 6;
			button_back.width = this.width / 24;
			button_back.height = this.height / 9;
			button_back.label = "<";
			button_back.enabled = false;
			button_back.mouseEnabled = false;
			
			//button_next.x = this.x + 5 * this.width / 6;
			//button_next.y = this.y + 5 * this.height / 6 + this.height / 18 + this.height / 36;
			//button_next.width = this.width / 12;
			//button_next.height = this.height / 18;
			
			button_next.x = this.width / 24 + 5.5 * this.width / 6;
			button_next.y = 2.5 * this.height / 6;
			button_next.width = this.width / 24;
			button_next.height = this.height / 9;
			button_next.label = ">";
			button_next.enabled = true;
			button_next.mouseEnabled = true;
			if(photos.length <= 9){
				button_next.enabled = false;
				button_next.mouseEnabled = false;
			}
			
			
			label.x =  2 * this.width / 6;
			label.y =  5 * this.height / 6 + this.height / 18 + this.height / 36;
			label.width = 2 * width / 6;
			label.height = this.height / 18;
			//label.setStyle("color","white");
			
			this.addElement(button_back);
			this.addElement(button_next);
			this.addElement(label);
		}
		
		public function mouseClickOnNext(event:MouseEvent):void{
			var i:int = 0;
			for(i = 0; i < 9; i++){
				photo_index[i] += 9;
				if(photo_index[i] < photos.length){
					set_image(i,photo_index[i]);
					if(button_back.enabled == false){
						button_back.enabled = true;
						button_back.mouseEnabled = true;
					}
				}
				else{
					set_image(i,photo_index[i]);
					button_next.enabled = false;
					button_next.mouseEnabled = false;
				}
			}
			for(i = 0; i < 9; i++){
				if(photo_index[i] == photos.length - 1)break;
			}
			if(i == 9) i = 8;
			label.text = (photo_index[0] + 1).toString() + " to " + (photo_index[i] + 1).toString() + " of " + photos.length.toString();
		}
		
		public function mouseClickOnBack(event:MouseEvent):void{
			var i:int = 0;
			for(i = 0; i < 9; i++){
				photo_index[i] -= 9;
				if(photo_index[i] >= 0){
					set_image(i,photo_index[i]);
					if(button_next.enabled == false){
						button_next.enabled = true;
						button_next.mouseEnabled = true;
					}
				}
			}
			if(photo_index[0] == 0){
				button_back.enabled = false;
				button_back.mouseEnabled = false;
			}
			label.text = (photo_index[0] + 1).toString() + " to " + (photo_index[8] + 1).toString() + " of " + photos.length.toString();
		}
		
		//private var myIsZoomed:Boolean = false;
		private var currentDepth:Number = 1;
		public function mouseClickOn(event:MouseEvent):void{
			//send(photos[photo_index[0]])
			//Alert.show("here");
			var ui3:UI3 = event.currentTarget as UI3;

			
			//Alert.show("zoom");
			//if (!ui3.isZoomed) {
				ui3.ui2 = this;
				// Alert.show(ui3.photo.title);
				//Alert.show("here");
				var zoomFull:Parallel = new Parallel();
				zoomFull.duration = 600;
				var zoom2:Zoom = new Zoom();
				zoom2.zoomHeightFrom = zoomOriginalScale;
				zoom2.zoomHeightTo = 1.0;
				zoom2.zoomWidthFrom = zoomOriginalScale;
				zoom2.zoomWidthTo = 1.0;
				zoom2.originX = 0;
				zoom2.originY = 0;
				
				var move:Move = new Move();
				move.xFrom = ui3.x;
				ui3.origX = ui3.x;
				move.yFrom = ui3.y;
				ui3.origY = ui3.y;
				move.xTo = 0;
				move.yTo = 0;
				
				zoomFull.addChild(zoom2);
				zoomFull.addChild(move);

				ui3.isZoomed = true;
				ui3.depth = this.currentDepth;
				this.currentDepth ++;
				ui3.removeEventListener(MouseEvent.CLICK,mouseClickOn);
				zoomFull.play([ui3]);
				
				flash.utils.setTimeout(function (ui3:UI3):void {ui3.buttonVisible(true);}, 600, ui3);
				
				//ui3.buttonVisible(true);
				//ui3.removeEventListener(MouseEvent.CLICK,mouseClickOn);
				//Alert.show("here");
			//}
			
		}
		
		private function buttonVisible(ui3:UI3, value:Boolean):void {
			ui3.buttonVisible(value);
		}
		
		public function set_image(i:int, index:int):void{
			if(index >= photos.length){
				switch(i){
					case 0: image0.visible = false;break;//image0.setImageUrl(source[index]); break;// .source = source[index];break;
					case 1: image1.visible = false;break;
					case 2: image2.visible = false;break;
					case 3: image3.visible = false;break;// = null;break;
					case 4: image4.visible = false;break;// = null;break;// image4.source = source[index];break;
					case 5: image5.visible = false;break;// = null;break;
					case 6: image6.visible = false;break;// = null;break;
					case 7: image7.visible = false;break;// = null;break;
					case 8: image8.visible = false;break;// = null;break;
					default: return;
				}
				return;
			}
			switch(i){
				case 0: image0.photo = photos[index]; image0.visible = true; break;//image0.setImageUrl(source[index]); break;// .source = source[index];break;
				case 1: image1.photo = photos[index]; image1.visible = true; break;
				case 2: image2.photo = photos[index]; image2.visible = true; break;
				case 3: image3.photo = photos[index]; image3.visible = true; break;
				case 4: image4.photo = photos[index]; image4.visible = true; break;// image4.source = source[index];break;
				case 5: image5.photo = photos[index]; image5.visible = true; break;
				case 6: image6.photo = photos[index]; image6.visible = true; break;
				case 7: image7.photo = photos[index]; image7.visible = true; break;
				case 8: image8.photo = photos[index]; image8.visible = true; break;
				default: return;
			}
		}
	}
}
