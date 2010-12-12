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
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.effects.Move;
	import mx.effects.Parallel;
	import mx.effects.Zoom;
	
	import spark.components.Button;
	import spark.components.Group;
	import spark.primitives.Rect;
	
	
	public class UI2 extends spark.components.Group
	{
		protected var source:Array;
		//protected var image0:Image;
		protected var image0:UI3;
		protected var image1:Image;
		protected var image2:Image;
		protected var image3:Image;
		protected var image4:UI3;
		protected var image5:Image;
		protected var image6:Image;
		protected var image7:Image;
		protected var image8:Image;
		
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
		
		public function UI2(){
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
			image1 = new Image();
			image1.addEventListener(MouseEvent.CLICK,mouseClickOnI1);
			this.addElement(image1);
			image2 = new Image();
			image2.addEventListener(MouseEvent.CLICK,mouseClickOnI2);
			this.addElement(image2);
			image3 = new Image();
			image3.addEventListener(MouseEvent.CLICK,mouseClickOnI3);
			this.addElement(image3);
			image4 = new UI3();//Image();
			image4.visible = false;
			image4.addEventListener(MouseEvent.CLICK,mouseClickOn);
			this.addElement(image4);
			image5 = new Image();
			image5.addEventListener(MouseEvent.CLICK,mouseClickOnI5);
			this.addElement(image5);
			image6 = new Image();
			image6.addEventListener(MouseEvent.CLICK,mouseClickOnI6);
			this.addElement(image6);
			image7 = new Image();
			image7.addEventListener(MouseEvent.CLICK,mouseClickOnI7);
			this.addElement(image7);
			image8 = new Image();
			image8.addEventListener(MouseEvent.CLICK,mouseClickOnI8);
			this.addElement(image8);
			flickr.addEventListener(FlickrResultEvent.PHOTOS_SEARCH, photosSearchEventHandler);
			
		}
		
		public function set_tag(t:String):void{
			tag = t;
			flickr.photos.search("", tag, "any", "", null, null, null, null, -1, "date-posted-desc", -1, "", -1, -1, -1, "", "", "", "","", "", "", false, "", "", -1, -1, "", 100, 1);
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
				image0.x = this.x + 0 * 2 * this.width / 6 + this.width / 12;
				image0.y = this.y + 0 * 2 * this.height / 6 + this.height / 18;
				image0.width = this.width;// / 6;
				image0.height = this.height;// / 6;
				// image0.source = source[0];
				//image0.setim
				//image0.setImageUrl(source[0]);
				animation.play([image0]);
				image0.photo = photos[photo_index[0]];
			}
			
			if(photos.length > 1){
				image1.x = this.x + 1 * 2 * this.width / 6 + this.width / 12;
				image1.y = this.y + 0 * 2 * this.height / 6 + this.height / 18;
				image1.width = this.width/ 6;
				image1.height = this.height / 6;
				image1.source = source[1];
			}
			
			if(photos.length > 2){
				image2.x = this.x + 2 * 2 * this.width / 6 + this.width / 12;
				image2.y = this.y + 0 * 2 * this.height / 6 + this.height / 18;
				image2.width = this.width / 6;
				image2.height = this.height / 6;
				image2.source = source[2];
			}
			
			if(photos.length > 3){
				image3.x = this.x + 0 * 2 * this.width / 6 + this.width / 12;
				image3.y = this.y + 1 * 2 * this.height / 6 + this.height / 18;
				image3.width = this.width / 6;
				image3.height = this.height / 6;
				image3.source = source[3];
			}
			
			if(photos.length > 4){
				image4.x = this.x + 1 * 2 * this.width / 6 + this.width / 12;
				image4.y = this.y + 1 * 2 * this.height / 6 + this.height / 18;
				image4.width = this.width;//6;
				image4.height = this.height;// / 6;
				//image4.source = source[4];
				animation.play([image4]);
				image4.photo = photos[photo_index[4]];
			}
			
			if(photos.length > 5){
				image5.x = this.x + 2 * 2 * this.width / 6 + this.width / 12;
				image5.y = this.y + 1 * 2 * this.height / 6 + this.height / 18;
				image5.width = this.width / 6;
				image5.height = this.height / 6;
				image5.source = source[5];
			}
			
			if(photos.length > 6){
				image6.x = this.x + 0 * 2 * this.width / 6 + this.width / 12;
				image6.y = this.y + 2 * 2 * this.height / 6 + this.height / 18;
				image6.width = this.width / 6;
				image6.height = this.height / 6;
				image6.source = source[6];
			}
			
			if(photos.length > 7){
				image7.x = this.x + 1 * 2 * this.width / 6 + this.width / 12;
				image7.y = this.y + 2 * 2 * this.height / 6 + this.height / 18;
				image7.width = this.width / 6;
				image7.height = this.height / 6;
				image7.source = source[7];
			}
			
			if(photos.length > 8){
				image8.x = this.x + 2 * 2 * this.width / 6 + this.width / 12;
				image8.y = this.y + 2 * 2 * this.height / 6 + this.height / 18;
				image8.width = this.width / 6;
				image8.height = this.height / 6;
				image8.source = source[8];
			}
			
			
			
			button_back.x = this.x + 0 * 2 * this.width / 6 + this.width / 12;
			button_back.y = this.y + 5 * this.height / 6 + this.height / 18 + this.height / 36;
			button_back.width = this.width / 12;
			button_back.height = this.height / 18;
			button_back.label = "<";
			button_back.enabled = false;
			button_back.mouseEnabled = false;
			
			button_next.x = this.x + 5 * this.width / 6;
			button_next.y = this.y + 5 * this.height / 6 + this.height / 18 + this.height / 36;
			button_next.width = this.width / 12;
			button_next.height = this.height / 18;
			button_next.label = ">";
			if(photos.length <= 9){
				button_next.enabled = false;
				button_next.mouseEnabled = false;
			}
			
			label.x = this.x + 2 * this.width / 6;
			label.y = this.y + 5 * this.height / 6 + this.height / 18 + this.height / 36;
			label.width = 2 * width / 6;
			label.height = this.height / 18;
			
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
				move.xTo = 75;
				move.yTo = 75;
				
				zoomFull.addChild(zoom2);
				zoomFull.addChild(move);

				ui3.isZoomed = true;
				ui3.depth = this.currentDepth;
				this.currentDepth ++;
				ui3.removeEventListener(MouseEvent.CLICK,mouseClickOn);
				zoomFull.play([ui3]);
				
				//ui3.removeEventListener(MouseEvent.CLICK,mouseClickOn);
				//Alert.show("here");
			//}
			
		}
		
		public function mouseClickOnI0(event:MouseEvent):void{
			//send(photos[photo_index[0]])
		}
		
		public function mouseClickOnI1(event:MouseEvent):void{
			//send(photos[photo_index[1]])
		}
		
		public function mouseClickOnI2(event:MouseEvent):void{
			//send(photos[photo_index[2]])
		}
		
		public function mouseClickOnI3(event:MouseEvent):void{
			//send(photos[photo_index[3]])
		}
		
		public function mouseClickOnI4(event:MouseEvent):void{
			//send(photos[photo_index[4]])
		}
		
		public function mouseClickOnI5(event:MouseEvent):void{
			//send(photos[photo_index[5]])
		}
		
		public function mouseClickOnI6(event:MouseEvent):void{
			//send(photos[photo_index[6]])
		}
		
		public function mouseClickOnI7(event:MouseEvent):void{
			//send(photos[photo_index[7]])
		}
		
		public function mouseClickOnI8(event:MouseEvent):void{
			//send(photos[photo_index[8]])
		}
		
		public function get_image(i:int):Image{
			switch(i){
				//case 0: return image0;
				case 1: return image1;
				case 2: return image2;
				case 3: return image3;
				//case 4: return image4;
				case 5: return image5;
				case 6: return image6;
				case 7: return image7;
				case 8: return image8;
				default: return null;
			}
		}
		public function set_image(i:int, index:int):void{
			if(index >= photos.length) source[index] = "";
			switch(i){
				case 0: image0.photo = photos[photo_index[0]];break;//image0.setImageUrl(source[index]); break;// .source = source[index];break;
				case 1: image1.source = source[index];break;
				case 2: image2.source = source[index];break;
				case 3: image3.source = source[index];break;
				case 4: image4.photo = photos[photo_index[4]];break;// image4.source = source[index];break;
				case 5: image5.source = source[index];break;
				case 6: image6.source = source[index];break;
				case 7: image7.source = source[index];break;
				case 8: image8.source = source[index];break;
				default: return;
			}
		}
	}
}
