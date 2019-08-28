<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <meta http-equiv="Page-Enter" content='blendTrans(Duration='0.3')' />
   <meta http-equiv="Page-Exit" content='blendTrans(Duration='0.3') />
    <%@ page language="java" contentType="text/html; charset=UTF-8"%>
   <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <title>Safety Map</title>
    <script src="./resources/js/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="./resources/js/examples-base.js"></script>
    <script type="text/javascript" src="./resources/js/highlight.min.js"></script>
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=83bfuniegk&amp;submodules=geocoder"></script>
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=83bfuniegk&amp;submodules=panorama"></script>
    <script src="https://code.jquery.com/jquery-1.12.4.min.js" integrity="sha256-ZosEbRLbNQzLpnKIkEdrPv7lOy9C27hHQ+Xp8a4MxAQ=" crossorigin="anonymous"></script>
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=kcdydbiwel"></script>
    <script type="text/javascript" src="./resources/js/MarkerClustering.js"></script>
    <link rel="stylesheet" type="text/css" href="./resources/css/examples-base.css" />
</head>
<body>

<style>
    #map .btn_mylct{z-index:100;overflow:hidden;display:inline-block;position:absolute;top:7px;left:5px;width:34px;height:34px;border:1px solid rgba(58,70,88,.45);border-radius:2px;background:#fcfcfd;text-align:center;-webkit-background-clip:padding;background-clip:padding-box}
    #map .spr_trff{overflow:hidden;display:inline-block;color:transparent!important;vertical-align:top;background:url(https://ssl.pstatic.net/static/maps/m/spr_trff_v6.png) 0 0;background-size:200px 200px;-webkit-background-size:200px 200px}
    #map .spr_ico_mylct{width:20px;height:20px;margin:7px 0 0 0;background-position:-153px -31px}
</style>
<style type="text/css">
.search { position:absolute;z-index:1000;top:10px;left:45px; }
.search #address { width:150px;height:20px;line-height:20px;border:solid 1px #555;padding:3px;font-size:12px;box-sizing:content-box; }
.search #submit { height:30px;line-height:30px;padding:0 10px;font-size:12px;border:solid 1px #555;border-radius:3px;cursor:pointer;box-sizing:content-box; }
.search #detail { height:30px;line-height:30px;padding:0 10px;font-size:12px;border:solid 1px #555;border-radius:3px;cursor:pointer;box-sizing:content-box; }
.select { position:absolute;z-index:1000;top:10px;left:335px; }
</style>

<!-- @category Overlay/Marker -->

<div id="map" style="width:100%;height:600px;">
<div class="search" style="">
            <input id="address" type="text" placeholder="주소를 입력하세요"/>
            <input id="submit" type="button" value="검색" />
            <input id ="detail" type="button" value="주소찾기"/>
</div>
<div class="select" style="">
         <fieldset style="background-color:white; text-align:center; vertical-align:middle; border-color:#DCDCDC;">        
           <input type="checkbox" id="cctv" name="cc">CCTV      
           <input type="checkbox" id="streetlamp" name="st">Streetlamp
         </fieldset>
</div>
<script src="http://dmaps.daum.net/map_js_init/postcode.v2.js"></script>
<script id="code">

//cctv db load
var cen_x = 36.7433987 , cen_y = 127.2331899 , index = 0;
var addr = new Array(), type = new Array(), posx = new Array(),posy = new Array();
var flag = 0;
var markerClustering1;
var markerClustering2;

var loadData = $.ajax({
      url :'./resources/data/cctv.json',
      type :"GET",
      contentType: "application/text; charset=UTF-8",
      dataType : "JSON",
      success : function(data){
         for(var sam = 0; sam < data.length; sam++){
            if(data[sam].posx < (cen_x+0.08) && data[sam].posx > (cen_x-0.05)){
               if(data[sam].posy < (cen_y+0.05) && data[sam].posy > (cen_y-0.05)){
                  posx[index] = data[index].posx;
                  posy[index] = data[index].posy;
                  type[index] = data[index].cctvType;
                  addr[index] = data[index].oldAddr;
                  index = index+1;
                  }
               }
            }
         }
      });



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
    zoom: 10,
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


var markers = [], //cctv markers
   markers2 = [], //streetlamp markers
    infoWindows = []; //cctv addr, cctv type information window
var contentstring = new Array(); // contentstring data array


//cctv marking function
function marking(){

//contentstring data push
for (let k = 0; k<300; k++){
      contentstring[k]= [
       '<div class="iw_inner">',
       '   <h3 style = "font-size:0.7em;">'+addr[k]+'</h3>',
       '   <p style = "font-size:0.5em;">'+type[k]+'<br />',
       '   </p>',
       '</div>'
     ].join('');
}

// make cctv marker
for (let i = 0; i<300; i++) {
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

naver.maps.Event.addListener(map, 'idle', function() {
    updateMarkers(map, markers);
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
            } else {
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
    map.setCenter(new naver.maps.LatLng(cen_x, cen_y));
    map.setZoom(12,true);
});
   

//streetlamp db load
var posx_s = new Array(), posy_s = new Array();
var index2 = 0;

var loadData2 = $.ajax({
   url :'./resources/data/street.json',
   type :"GET",
   contentType: "application/text; charset=UTF-8",
   dataType : "JSON",
   success : function(data){
      for(var sam = 0; sam < data.length; sam++){
         if(data[sam].posx < cen_x+0.05 && data[sam].posx > cen_x-0.05)
            if(data[sam].posy < cen_y+0.05 && data[sam].posy > cen_y-0.05){
               posx_s[index2] = data[index2].posx;
               posy_s[index2] = data[index2].posy;
               index2 = index2+1;
            }
         }
      }
   });

//streetlamp marking function
function marking2(){
   
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

        infoWindow.setContent([
                '<div style="padding:10px;min-width:200px;line-height:150%;">',
                '<h4 style="margin-top:5px;">검색 좌표</h4><br />',
                htmlAddresses.join('<br />'),
                '</div>'
            ].join('\n'));

        infoWindow.open(map, latlng);
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

function checkbox1(){
   $('input[name="cc"]').change(function(){
      if($('input[name="cc"]').is(":checked")){
         marking();
      }
      else{
         remove1();
         markerClustering1.setMap(null);
      }
   });
}

function remove1(){
   for (var i = 0; i < markers.length; i++) {
      var marker = markers[i]
        marker.setMap(null);
    }
   markers = [];
}

function checkbox2(){
   $('input[name="st"]').change(function(){
      var value = $(this).val();
      var checked = $(this).prop('checked');
      if(checked){
         marking2();
      }
      else{
         remove2();
         markerClustering2.setMap(null);
      }
   });
}

function remove2(){
   for (var i = 0; i < markers2.length; i++) {
      var marker2 = markers2[i]
        marker2.setMap(null);
    }
    markers2 = [];
}

//cctv, streetlamp marker promise
getPosition()
.then((position) => { //get gps position
   cen_x = 36.765494; //임시 좌표
   cen_y = 127.282274; //임시좌표
   //cen_x = position.coords.latitude; //현재 gps 좌표
   //cen_y = position.coords.longitude; //현재 gps 좌표
   map.setCenter(naver.maps.LatLng(cen_x,cen_y));
   var mylocation = new naver.maps.Marker({ //현재 위치 좌표 마커 표시
           map: map,
           position: naver.maps.LatLng(cen_x,cen_y),
           zIndex: 100,
           icon:{
              url:'./resources/images/mylocation.png'
           }
       });
 })
 .then((position) => { //cctv marker maker
    loadData.then(checkbox1); 
 })
 .then((position) => { //streetlamp marker maker
    loadData2.then(checkbox2);
 })
 .then((position) => {
    //search(cen_x,cen_y);
 })
 .catch((err) => {
  alert(err.message);
 });

   
</script>
</body>
</html>