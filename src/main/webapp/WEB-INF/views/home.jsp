<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
    <%@ page language="java" contentType="text/html; charset=UTF-8"%>
	<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
    <title>Doit</title>
    <script src="../../docs/js/jquery-1.9.1.js"></script>
    <script type="text/javascript" src="../../docs/js/examples-base.js"></script>
    <script type="text/javascript" src="../../docs/js/highlight.min.js"></script>
    <script type="text/javascript" src="https://openapi.map.naver.com/openapi/v3/maps.js?ncpClientId=83bfuniegk&amp;submodules=panorama"></script>
    <link rel="stylesheet" type="text/css" href="../../docs/css/examples-base.css" />
    <script>
        var HOME_PATH = '../../docs';
    </script>
</head>
<body>

<!-- @category Overlay/Marker -->

<div id="map" style="width:100%;height:600px;"></div>
<script id="code">

var cen_x = 36.765797;
var cen_y = 127.282328;
var addr = new Array();
var type = new Array();
var posx = new Array();
var posy = new Array();
var cnt = 0;

<c:forEach items="${memberList}" var="member">
	<c:if test = "${member.posx < 36.765797 and member.posx > 36.735797}">
		<c:if test = "${member.posy < 127.282328 and member.posy > 127.052328}">
			addr[cnt] = "${member.oldAddr}";
			type[cnt] = "${member.cctvType}";
			posx[cnt] = "${member.posx}";
			posy[cnt] = "${member.posy}";
			cnt = cnt+1;	
		</c:if>
	</c:if>
</c:forEach>
document.write("CCTV CNT:" + cnt);
var HOME_PATH = window.HOME_PATH || '.';

var map = new naver.maps.Map('map', {
    center: new naver.maps.LatLng(36.765797, 127.282328),
    zoom: 12
});

var bounds = map.getBounds(),
    southWest = bounds.getSW(),
    northEast = bounds.getNE(),
    lngSpan = northEast.lng() - southWest.lng(),
    latSpan = northEast.lat() - southWest.lat();

var markers = [],
    infoWindows = [];
var contentstring = new Array();

for (let k = 0; k<300; k++){
	contentstring[k]= [
        '<div class="iw_inner">',
        '   <h3 style = "font-size:0.7em;">'+addr[k]+'</h3>',
        '   <p style = "font-size:0.5em;">'+type[k]+'<br />',
        '   </p>',
        '</div>'
    ].join('');
}
for (let i = 0; i<300; i++) {

    var position = new naver.maps.LatLng(
    		posx[i], posy[i]);

        var marker = new naver.maps.Marker({
            map: map,
            position: position,
            zIndex: 100
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

naver.maps.Event.addListener(map, 'idle', function() {
    updateMarkers(map, markers);
});

function updateMarkers(map, markers) {

    var mapBounds = map.getBounds();
    var marker, position;

    for (var i = 0; i < markers.length; i++) {

        marker = markers[i]
        position = marker.getPosition();

        if (mapBounds.hasLatLng(position)) {
            showMarker(map, marker);
        } else {
            hideMarker(map, marker);
        }
    }
}

function showMarker(map, marker) {

    if (marker.setMap()) return;
    marker.setMap(map);
}

function hideMarker(map, marker) {

    if (!marker.setMap()) return;
    marker.setMap(null);
}

// 해당 마커의 인덱스를 seq라는 클로저 변수로 저장하는 이벤트 핸들러를 반환합니다.
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

for (var i=0, ii=markers.length; i<ii; i++) {
    naver.maps.Event.addListener(markers[i], 'click', getClickHandler(i));
}
</script>

</body>
</html>
