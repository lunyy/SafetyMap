<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport"
	content="width=device-width, initial-scale=1.0, user-scalable=no">
<meta http-equiv="Page-Enter" content='blendTrans(Duration=' 0.3')' />
<meta http-equiv="Page-Exit" content='blendTrans(Duration=' 0.3') />
<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<title>Safety Map</title>
<script src="./resources/js/jquery-1.9.1.js"></script>
<script type="text/javascript" src="./resources/js/examples-base.js"></script>
<script type="text/javascript" src="./resources/js/highlight.min.js"></script>
<script type="text/javascript"
	src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=83bfuniegk&amp;submodules=geocoder"></script>
<script type="text/javascript"
	src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=83bfuniegk&amp;submodules=panorama"></script>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"
	integrity="sha256-ZosEbRLbNQzLpnKIkEdrPv7lOy9C27hHQ+Xp8a4MxAQ="
	crossorigin="anonymous"></script>
<script type="text/javascript"
	src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=kcdydbiwel"></script>
<script type="text/javascript" src="./resources/js/MarkerClustering.js"></script>
<link rel="stylesheet" type="text/css"
	href="./resources/css/examples-base.css" />
</head>
<body>

	<style>
#map .btn_mylct {
	z-index: 100;
	overflow: hidden;
	display: inline-block;
	position: absolute;
	top: 7px;
	left: 5px;
	width: 34px;
	height: 34px;
	border: 1px solid rgba(58, 70, 88, .45);
	border-radius: 2px;
	background: #fcfcfd;
	text-align: center;
	-webkit-background-clip: padding;
	background-clip: padding-box
}

#map .spr_trff {
	overflow: hidden;
	display: inline-block;
	color: transparent !important;
	vertical-align: top;
	background: url(https://ssl.pstatic.net/static/maps/m/spr_trff_v6.png) 0
		0;
	background-size: 200px 200px;
	-webkit-background-size: 200px 200px
}

#map .spr_ico_mylct {
	width: 20px;
	height: 20px;
	margin: 7px 0 0 0;
	background-position: -153px -31px
}
</style>
	<style type="text/css">
.search {
	position: absolute;
	z-index: 1000;
	top: 10px;
	left: 45px;
}

.search #address {
	width: 150px;
	height: 20px;
	line-height: 20px;
	border: solid 1px #555;
	padding: 3px;
	font-size: 12px;
	box-sizing: content-box;
}

.search #submit {
	height: 30px;
	line-height: 30px;
	padding: 0 10px;
	font-size: 12px;
	border: solid 1px #555;
	border-radius: 3px;
	cursor: pointer;
	box-sizing: content-box;
}

.search #detail {
	height: 30px;
	line-height: 30px;
	padding: 0 10px;
	font-size: 12px;
	border: solid 1px #555;
	border-radius: 3px;
	cursor: pointer;
	box-sizing: content-box;
}

.select {
	position: absolute;
	z-index: 1000;
	top: 10px;
	left: 45px;
}
</style>

	<!-- @category Overlay/Marker -->

	<div id="map" style="width: 100%; height: 600px;">
		<div class="select" style="">
			<fieldset
				style="background-color: white; text-align: center; vertical-align: middle; border-color: #DCDCDC;">
				<input type="checkbox" id="cctv" name="cc">CCTV <input
					type="checkbox" id="streetlamp" name="st">가로등<input
					type="checkbox" id="police" name="po">경찰서<input
					type="checkbox" id="searchAddress" name="ad">주소
			</fieldset>
		</div>
		<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
		<script id="code">


//cctv db load
var gps_x = 0, gps_y = 0;
var cen_x = 0, cen_y = 0 , index_c = 0;
var addr = new Array(), type = new Array(), posx = new Array(),posy = new Array();
var flag = 1, flag2 = 1, flag3 = 1;
var markerClustering1,markerClustering2;
var load = 0;

var markers = [], //cctv markers
markers2 = [], //streetlamp markers
markers3 = [], //police markers
infoWindows = [], //cctv addr, cctv type information window
infoWindows2 = []; //police markers information window
var contentstring = new Array(), // contentstring data array
contentstring2 = new Array();

function getData(){ //cctv ajax 호출
    return new Promise(function(resolve, reject) {
        $.ajax({
            url : './resources/data/cctv.json',
            type : 'GET',
            contentType : 'application/text; charset=UTF-8',
            dataType : 'JSON',
            cache : false,
            success : function(data) {
                resolve(data);
            },
            error: function(error) {
                reject(error);
            }
        })
    })
}

//cctv marking function
function marking_cctv(){

//contentstring data push
for (let k = 0; k<1000; k++){
      contentstring[k]= [
       '<div class="iw_inner">',
       '   <h3 style = "font-size:0.7em;">'+addr[k]+'</h3>',
       '   <p style = "font-size:0.7em;">'+type[k]+'<br />',
       '   </p>',
       '</div>'
     ].join('');
}

// make cctv marker
for (let i = 0; i<1000; i++) {
       var position = new naver.maps.LatLng(
          posx[i], posy[i]);

        var marker = new naver.maps.Marker({
            map: map,
            position: position,
            zIndex: 100,
            icon:{
               url:'./resources/images/cctv2.png'
            }
        });

        var infoWindow = new naver.maps.InfoWindow({
            borderColor: "#A4A4A4",
            borderWidth: 2,
            maxWidth: 140,
            content:contentstring[i]
        });

        markers.push(marker);
        infoWindows.push(infoWindow);
   };
   
for (var i=0, ii=markers.length; i<ii; i++) {
     naver.maps.Event.addListener(markers[i], 'click', getClickHandler(i));
     }
var cctvMarker1 = {
        content: '<div style="cursor:pointer;width:40px;height:40px;line-height:42px;font-size:10px;color:white;text-align:center;font-weight:bold;background:url(./resources/images/cctv_c5.png);background-size:contain;"></div>',
        size: N.Size(40, 40),
        anchor: N.Point(20, 20)
    },
    cctvMarker2 = {
        content: '<div style="cursor:pointer;width:40px;height:40px;line-height:42px;font-size:10px;color:white;text-align:center;font-weight:bold;background:url(./resources/images/cctv_c4.png);background-size:contain;"></div>',
        size: N.Size(40, 40),
        anchor: N.Point(20, 20)
    },
    cctvMarker3 = {
        content: '<div style="cursor:pointer;width:40px;height:40px;line-height:42px;font-size:10px;color:white;text-align:center;font-weight:bold;background:url(./resources/images/cctv_c3.png);background-size:contain;"></div>',
        size: N.Size(40, 40),
        anchor: N.Point(20, 20)
    },
    cctvMarker4 = {
        content: '<div style="cursor:pointer;width:40px;height:40px;line-height:42px;font-size:10px;color:white;text-align:center;font-weight:bold;background:url(./resources/images/cctv_c2.png);background-size:contain;"></div>',
        size: N.Size(40, 40),
        anchor: N.Point(20, 20)
    },
    cctvMarker5 = {
        content: '<div style="cursor:pointer;width:40px;height:40px;line-height:42px;font-size:10px;color:white;text-align:center;font-weight:bold;background:url(./resources/images/cctv_c1.png);background-size:contain;"></div>',
        size: N.Size(40, 40),
        anchor: N.Point(20, 20)
    };

    //cctv marker clustering module
       markerClustering1 = new MarkerClustering({
        minClusterSize: 2,
        maxZoom: 12,
        map: map,
        markers: markers,
        disableClickZoom: false,
        gridSize: 120,
        icons: [cctvMarker1, cctvMarker2, cctvMarker3, cctvMarker4, cctvMarker5],
        indexGenerator: [10, 30, 50, 100, 200],
        stylingFunction: function(clusterMarker, count) {
            $(clusterMarker.getElement()).find('div:first-child').text(count);
        }
    });
}

//streetlamp db load
var posx_s = new Array(), posy_s = new Array();
var index_s = 0;

function getData2(){ // street lamp ajax 호출 
    return new Promise(function(resolve, reject) {
        $.ajax({
            url : './resources/data/street.json',
            type : 'GET',
            contentType : 'application/text; charset=UTF-8',
            dataType : 'JSON',
            cache : false,
            success : function(data) {
                resolve(data);
            },
            error: function(error) {
                reject(error);
            }
        })
    })
}

//streetlamp marking function
function marking_streetlamp(){
   
   for (let j = 0; j<2000; j++){
       var position2 = new naver.maps.LatLng(
            posx_s[j], posy_s[j]);

       var marker2 = new naver.maps.Marker({
              map: map,
              position: position2,
              zIndex: 100,
              icon:{
                 url:'./resources/images/streetlamp.png'
              }
          });

        markers2.push(marker2);
   }
   
//street lamp clustering icon
var streetlampMarker1 = {
           content: '<div style="cursor:pointer;width:40px;height:40px;line-height:42px;font-size:10px;color:white;text-align:center;font-weight:bold;background:url(./resources/images/streetlamp_c3.png);background-size:contain;"></div>',
           size: N.Size(40, 40),
           anchor: N.Point(20, 20)
     },
    streetlampMarker2 = {
           content: '<div style="cursor:pointer;width:40px;height:40px;line-height:42px;font-size:10px;color:white;text-align:center;font-weight:bold;background:url(./resources/images/streetlamp_c2.png);background-size:contain;"></div>',
           size: N.Size(40, 40),
           anchor: N.Point(20, 20)
     },
     streetlampMarker3 = {
           content: '<div style="cursor:pointer;width:40px;height:40px;line-height:42px;font-size:10px;color:white;text-align:center;font-weight:bold;background:url(./resources/images/streetlamp_c1.png);background-size:contain;"></div>',
           size: N.Size(40, 40),
           anchor: N.Point(20, 20)
};
      
//streetlamp marker clustering module
	markerClustering2 = new MarkerClustering({
       minClusterSize: 2,
       maxZoom: 13,
       map: map,
       markers: markers2,
       disableClickZoom: false,
       gridSize: 120,
       icons: [streetlampMarker1, streetlampMarker2, streetlampMarker3],
       indexGenerator: [10,30,100],
       stylingFunction: function(clusterMarker, count) {
           $(clusterMarker.getElement()).find('div:first-child').text(count);
       }
   });
}

var posx_p = new Array();
var posy_p = new Array();
var address_p = new Array();
var phoneNo_p = new Array();
var name_p = new Array();
var districtOffice_p = new Array();
var section_p = new Array();

//police data load
var loadData3 = $.ajax({
    url :'./resources/data/police.json',
    type :"GET",
    contentType: "application/text; charset=UTF-8",
    dataType : "JSON",
    success : function(data){
      		for(var sam = 0; sam < 18; sam++){
      			name_p[sam] = data[sam].name;
      			section_p[sam] = data[sam].section;
                posx_p[sam] = data[sam].posx;
                posy_p[sam] = data[sam].posy;
                phoneNo_p[sam] = data[sam].phoneNo;
                address_p[sam] = data[sam].address;
			}
	}
});


function marking_police(){
	//contentstring data push
	
	for (let k = 0; k<18; k++){
	      contentstring2[k]= [
	       '<div class="iw_inner">',
	       '   <h3 style = "font-size:0.7em;">'+name_p[k]+section_p[k]+'</h3>',
	       '   <p style = "font-size:0.7em;">'+phoneNo_p[k]+'<br />',
	       '   </p>',
	       '</div>'
	     ].join('');
		}

	// make police marker
	for (let i = 0; i<18; i++) {
	       var position = new naver.maps.LatLng(
	          posx_p[i], posy_p[i]);

	        var marker = new naver.maps.Marker({
	            map: map,
	            position: position,
	            zIndex: 100,
	            icon:{
	                url:'./resources/images/police.png'
	             }
	        });

	        var infoWindow2 = new naver.maps.InfoWindow({
	            borderColor: "#A4A4A4",
	            borderWidth: 2,
	            maxWidth: 140,
	            content:contentstring2[i]
	        });

	        markers3.push(marker);
	        infoWindows2.push(infoWindow2);
	   };
	   
	   for (var i=0, ii=markers3.length; i<ii; i++) {
		    naver.maps.Event.addListener(markers3[i], 'click', getClickHandler2(i));
		    }
}	   

var HOME_PATH = window.HOME_PATH || '.';

//gps position load
var getPosition = function (options) {
     return new Promise(function (resolve, reject) {
       navigator.geolocation.getCurrentPosition(resolve, reject, options);
     });
   }

//map load
var map = new naver.maps.Map('map', {
   position: naver.maps.LatLng(cen_x,cen_y),
    zoom: 7,
    zoomControl: true,
    zoomControlOptions: {
        position: naver.maps.Position.TOP_RIGHT,
        style: naver.maps.ZoomControlStyle.SMALL
    },
    mapTypeControl: true,
    mapTypeControlOptions: {
       style:naver.maps.MapTypeControlStyle.BUTTON,
       position: naver.maps.Position.TOP_RIGHT
    }
});

var bounds = map.getBounds(),
    southWest = bounds.getSW(),
    northEast = bounds.getNE(),
    lngSpan = northEast.lng() - southWest.lng(),
    latSpan = northEast.lat() - southWest.lat();

naver.maps.Event.addListener(map, 'idle', function() {
    updateMarkers(map, markers);
    updateMarkers(map, markers3);
});

// cctv marker clustering icon

function refreshmap(){
	location.reload();
}

//지도 화면 안에 들어오는 마커 show (마커가 지도 밖에 있으면 hide)를 위한 module
    function updateMarkers(map, markers) {

        var mapBounds = map.getBounds();
        var marker, position;

        //refreshmap();

        for (var i = 0; i < markers.length; i++) {

            marker = markers[i];
            position = marker.getPosition();

            if (mapBounds.hasLatLng(position)) {
                showMarker(map, marker);

            } else {
                hideMarker(map, marker);
            }
        }
    }

    //지도 화면 안에 들어오는 마커 show (마커가 지도 밖에 있으면 hide)
    function showMarker(map, marker) {

        if (marker.setMap()) return;
        marker.setMap(map);
    }

    function hideMarker(map, marker) {

        if (!marker.setMap()) return;
        marker.setMap(null);
    }

    // 해당 마커의 인덱스를 seq라는 클로저 변수로 저장하는 이벤트 핸들러를 반환
    function getClickHandler(seq) {
        return function(e) {
            var marker = markers[seq],
                infoWindow = infoWindows[seq];

            if (infoWindow.getMap()) {
                infoWindow.close();
            }
            else {
                infoWindow.open(map, marker);
            }
        }
    }

    function getClickHandler2(seq) {
        return function(e) {
            var marker = markers3[seq],
                infoWindow = infoWindows2[seq];

            if (infoWindow.getMap()) {
                infoWindow.close();
            }
            else {
                infoWindow.open(map, marker);
            }
        }
    }
//go back to user position(원하는 좌표로 이동하는 버튼 - 추후에 사용자 gps 받아서 사용자 위치로 이동하는 버튼으로 수정 예정)
var locationBtnHtml = '<a href="#" class="btn_mylct"><span class="spr_trff spr_ico_mylct">user location</span></a>';

//customControl 객체 이용하기
var customControl = new naver.maps.CustomControl(locationBtnHtml, {
        position: naver.maps.Position.TOP_LEFT
});

customControl.setMap(map);

var domEventListener = naver.maps.Event.addDOMListener(customControl.getElement(), 'click', function() {
    map.setCenter(new naver.maps.LatLng(gps_x, gps_y));
    map.setZoom(10,true);
});
   

var infoWindow = new naver.maps.InfoWindow({
    anchorSkew: true
});

map.setCursor('pointer');

// search by tm128 coordinate
function searchCoordinateToAddress(latlng) {
    var tm128 = naver.maps.TransCoord.fromLatLngToTM128(latlng);

    infoWindow.close();

    naver.maps.Service.reverseGeocode({
        location: tm128,
        coordType: naver.maps.Service.CoordType.TM128
    }, function(status, response) {
        if (status === naver.maps.Service.Status.ERROR) {
            return alert('Something Wrong!');
        }

        var items = response.result.items,
            htmlAddresses = [];

        for (var i=0, ii=items.length, item, addrType; i<ii; i++) {
            item = items[i];
            addrType = item.isRoadAddress ? '[도로명 주소]' : '[지번 주소]';

            htmlAddresses.push((i+1) +'. '+ addrType +' '+ item.address);
        }

        if(flag == 0){
        infoWindow.setContent([
                '<div style="padding:10px;min-width:200px;line-height:150%;">',
                '<h4 style="margin-top:5px;">검색 좌표</h4><br />',
                htmlAddresses.join('<br />'),
                '</div>'
            ].join('\n'));

        infoWindow.open(map, latlng);
        }
    });
}

// result by latlng coordinate
function searchAddressToCoordinate(address) {
    naver.maps.Service.geocode({
        address: address
    }, function(status, response) {
        if (status === naver.maps.Service.Status.ERROR) {
            return alert('Something Wrong!');
        }

        var item = response.result.items[0],
            addrType = item.isRoadAddress ? '[도로명 주소]' : '[지번 주소]',
            point = new naver.maps.Point(item.point.x, item.point.y);

        infoWindow.setContent([
                '<div style="padding:10px;min-width:200px;line-height:150%;">',
                '<h4 style="margin-top:5px;">검색 주소 : '+ response.result.userquery +'</h4><br />',
                addrType +' '+ item.address +'<br />',
                '</div>'
            ].join('\n'));


        map.setCenter(point);
        infoWindow.open(map, point);
    });
}

function initGeocoder() {
    map.addListener('click', function(e) {
        searchCoordinateToAddress(e.coord);
    });

    $('#address').on('keydown', function(e) {
        var keyCode = e.which;

        if (keyCode === 13) { // Enter Key
            searchAddressToCoordinate($('#address').val());
        }
    });
    $('#submit').on('click', function(e) {
        e.preventDefault();
        searchAddressToCoordinate($('#address').val());
    });
    $('#detail').on('click', function(e) {
        e.preventDefault();
        new daum.Postcode({
            oncomplete: function(data) {
               var addr = data.address; // 최종 주소 변수
                // 주소 정보를 해당 필드에 넣는다.
                document.getElementById("address").value = addr;
            }
        }).open();
    });
}

naver.maps.onJSContentLoaded = initGeocoder;

function search(cen_x,cen_y){
   var position = new naver.maps.LatLng(cen_x, cen_y);
   var searchlocation = new naver.maps.Marker({
       position: position,
       map: map
   });
   map.addListener('click', function(e) {
        searchlocation.setPosition(e.coord);
    });
}

function searchBt(){ // SEARCH!!!
    $('#submit').on('click', function(e) {
           e.preventDefault();
           searchAddressToCoordinate($('#address').val());
       });
}

function checkbox_cctv(){
   $('input[name="cc"]').change(function(){
	  var value = $(this).val();
	  var checked = $(this).prop('checked');
      if(checked){
    	  getData().then((data) => { 
    	  	 var pos = map.getCenter();
    	     cen_x = pos.lat();
    	     cen_y = pos.lng();
    	     var x_plus = parseFloat(cen_x+0.03).toFixed(3);
    	     var x_minus = parseFloat(cen_x-0.03).toFixed(3);
    	     var y_plus = parseFloat(cen_y+0.03).toFixed(3);
    	     var y_minus = parseFloat(cen_y-0.03).toFixed(3);
    	  	 for(var sam = 0; sam < data.length; sam++){
    	  		var temp_x = parseFloat(data[sam].posx).toFixed(3);
     	  		var temp_y = parseFloat(data[sam].posy).toFixed(3);
     	  		var temp_type = data[sam].cctvType;
     	  		var temp_addr = data[sam].oldAddr;
    	           if((x_minus < temp_x) && (temp_x <= x_plus)){
    	              if((y_minus < temp_y) && (temp_y <= y_plus)){
    	                 posx[index_c] = temp_x;
    	                 posy[index_c] = temp_y;
    	                 type[index_c] = temp_type;
    	                 addr[index_c] = temp_addr;
    	                 index_c = index_c+1;
    	                 }
    	            }
    	  	 }
    	  }).then((data) => {
    		marking_cctv();
    	  }).catch((err) => {
    	  	alert("Woops!");
    	  });	   
      }
      else{
        remove_cctv();
        markerClustering1.setMap(null);
       	index_c = 0;
       	posx = [], posy = [], type = [], addr = [];
      }
   });
}

function remove_cctv(){
   for (var i = 0; i < markers.length; i++) {
      var marker = markers[i];
      marker.setMap(null);
    }
   for (var ii = 0; ii < infoWindows.length; ii++){
	   var infowindow = infoWindows[ii];
	   infowindow.setMap(null);
   }
   markers = [];
   infoWindows = [];
  
}

function checkbox_streetlamp(){
   $('input[name="st"]').change(function(){
      var value = $(this).val();
      var checked = $(this).prop('checked');
      if(checked){
    	  getData2().then((data) => { 
     	  	 pos = map.getCenter();
     	     cen_x = pos.lat();
     	     cen_y = pos.lng();
     	     var x_plus2 = parseFloat(cen_x+0.03).toFixed(3);
     	     var x_minus2 = parseFloat(cen_x-0.03).toFixed(3);
     	     var y_plus2 = parseFloat(cen_y+0.03).toFixed(3);
     	     var y_minus2 = parseFloat(cen_y-0.03).toFixed(3);
     	  	 for(var sam = 0; sam < data.length; sam++){
     	  		 var temp_x = parseFloat(data[sam].posx).toFixed(3);
     	  		 var temp_y = parseFloat(data[sam].posy).toFixed(3);
     	           if((temp_x <= x_plus2)&&(temp_x > x_minus2)){
     	              if((temp_y <= y_plus2)&&(temp_y > y_minus2)){
     	                 posx_s[index_s] = temp_x;
     	                 posy_s[index_s] = temp_y;
     	                 index_s = index_s+1;
     	                 }
     	            }
     	  	 }
     	  }).then((data) => {
     		 marking_streetlamp();
     	  }).catch((err) => {
     	  	alert("Woops!");
     	  });	   
      }
      else{
         remove_streetlamp();
         markerClustering2.setMap(null);
         index_s = 0;
         posx_s = [];
         posy_s = [];
      }
   });
}

function remove_streetlamp(){
   for (var i = 0; i < markers2.length; i++) {
      var marker2 = markers2[i];
      marker2.setMap(null);
    }
    markers2 = [];
}

function checkbox_police(){
	   $('input[name="po"]').change(function(){
	      var value = $(this).val();
	      var checked = $(this).prop('checked');
	      if(checked){
	      	marking_police();
	      }
	      else{
	        remove_police();
	      }
	   });
	}	

function remove_police(){
	   for (var i = 0; i < markers3.length; i++) {
	      var marker3 = markers3[i];
	      marker3.setMap(null);
	    }
	   for (var ii = 0; ii < infoWindows2.length; ii++){
		   var infowindow = infoWindows2[ii];
		   infowindow.setMap(null);
	   }
	    markers3 = [];
	    infoWindows2 = [];
	}

function checkbox_search(){
	   $('input[name="ad"]').change(function(){
	      var value = $(this).val();
	      var checked = $(this).prop('checked');
	      if(checked){
	         flag = 0;
	      }
	      else{
	         flag = 1;
	         infoWindow.close();
	      }
	   });
	}

//cctv, streetlamp marker promise
getPosition()
.then((position) => { //get gps position
   gps_x = 36.765494; //임시 좌표
   gps_y = 127.282274; //임시좌표
   //gps_x = position.coords.latitude; //현재 gps 좌표
   //gps_y = position.coords.longitude; //현재 gps 좌표
   map.setCenter(naver.maps.LatLng(gps_x,gps_y));
   var mylocation = new naver.maps.Marker({ //현재 위치 좌표 마커 표시
           map: map,
           position: naver.maps.LatLng(gps_x,gps_y),
           zIndex: 100,
           icon:{
              url:'./resources/images/mylocation.png'
           }
       });
 })
  .then((position) => { //streetlamp marker maker
   checkbox_cctv();
 })
 .then((position) => { //streetlamp marker maker
   checkbox_streetlamp();
 })
 .then((position) => {
    //search(cen_x,cen_y);
    loadData3.then(checkbox_police);
 })
 .then((position) => {
    //search(cen_x,cen_y);
    checkbox_search();
 })
 .catch((err) => {
  alert(err.message);
 });


    
</script>
</body>
</html>
