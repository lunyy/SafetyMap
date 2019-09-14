<!DOCTYPE html>
<html>
	<head>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport"
			content="width=device-width, initial-scale=1, shrink-to-fit=no">
		
		<%@ page language="java" contentType="text/html; charset=UTF-8"%>
		<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
		
		<title>Cheonan Satefy Map</title>
		
		<!-- Custom fonts for this template-->
		<link href="resources/assets/vendor/fontawesome-free/css/all.min.css"
			rel="stylesheet" type="text/css">
		<link
			href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i"
			rel="stylesheet">
		<!-- Custom styles for this template-->
		<link href="resources/assets/css/sb-admin-2.min.css" rel="stylesheet">
			
	</head>
	<body id="page-top">
		<style>
			body {
				font-family: nanumgothic, �굹�닎怨좊뵓, NanumGothic, "Malgun Gothic", �룍��, Dotum, AppleGothic, sans-serif;
			}
		</style>
	
		<!-- Page Wrapper -->
		<div id="wrapper">
	
			<!-- Sidebar -->
			<ul
				class="navbar-nav bg-gradient-primary sidebar sidebar-dark accordion"
				id="accordionSidebar">
	
				<!-- Sidebar - Brand -->
				<a
					class="sidebar-brand d-flex align-items-center justify-content-center"
					href="search">
					<div class="sidebar-brand-icon rotate-n-15">
						<i class="fas fa-map"></i>
					</div>
					<div class="sidebar-brand-text mx-3">Cheonan Safety Map</div>
				</a>
	
				<!-- Divider -->
				<hr class="sidebar-divider my-0">
	
				<li class="nav-item">
					<button class="nav-link" id="police_button"
						onclick="police_button_click();"
						style="background-color: transparent; border-color: transparent;">
						<img src="./resources/images/noun_police.png" class="fas fa-fw"> <span>Police</span>
					</button>
				</li>
	
				<li class="nav-item">
					<button class="nav-link" id="cctv_button"
						onclick="cctv_button_click();"
						style="background-color: transparent; border-color: transparent;">
						<img src="./resources/images/noun_cctv.png" class="fas fa-fw"> <span>CCTV</span>
					</button>
				</li>
	
				<li class="nav-item">
					<button class="nav-link" id="streetlamp_button"
						onclick="streetlamp_button_click();"
						style="background-color: transparent; border-color: transparent;">
						<img src="./resources/images/noun_streetlamp.png" class="fas fa-fw"> <span>Street
							Lamp</span>
					</button>
				</li>
	
				<!-- Divider -->
				<hr class="sidebar-divider">
	
				<!-- Nav Item - Utilities Collapse Menu -->
				<li class="nav-item"><a class="nav-link collapsed" href="#"
					data-toggle="collapse" data-target="#collapseUtilities"
					aria-expanded="true" aria-controls="collapseUtilities"> 
					<img src="./resources/images/noun_crime.png" class="fas fa-fw"> <span>Crime</span>
				</a>
					<div id="collapseUtilities" class="collapse"
						aria-labelledby="headingUtilities" data-parent="#accordionSidebar">
						<div class="bg-white py-2 collapse-inner rounded">
							<h6 class="collapse-header">Category</h6>
							<c:forEach var="n" items="${memberList2}">
							<c:choose>
								<c:when test="${n.is_criminal == 1}">
									<c:set var="violence" value="${violence+1}"/>
								</c:when>
								<c:when test="${n.is_criminal == 2}">
									<c:set var="sviolence" value="${sviolence+1}"/>
								</c:when>
								<c:when test="${n.is_criminal == 3}">
									<c:set var="theft" value="${theft+1}"/>
								</c:when>
								<c:when test="${n.is_criminal == 4}">
									<c:set var="robbery" value="${robbery+1}"/>
								</c:when>
								<c:when test="${n.is_criminal == 5}">
									<c:set var="murder" value="${murder+1}"/>
								</c:when>
								
							</c:choose>
						</c:forEach>
						<a class="collapse-item" id="violence" href="./violence">폭력  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
							<c:out value="${violence}"/>
						건</a> 
						<a class="collapse-item" id="Sviolence" href="./sviolence">성폭력  &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
							<c:out value="${sviolence}"/>
						건</a>
						<a class="collapse-item" id="theft" href="./theft">절도 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 
							<c:out value="${theft}"/>
						건</a>
						<a class="collapse-item" id="robbery" href="./robbery">강도 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; 
							<c:out value="${robbery}"/>
						건</a>
						<a class="collapse-item" id="murder" href="./murder">살인 &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;
							<c:out value="${murder}"/>
						건</a>
						</div>
					</div></li>
	
				<!-- Divider -->
				<hr class="sidebar-divider">
	
				<!-- Heading -->
				<div class="sidebar-heading">Interface</div>
	
				<!-- Nav Item - Pages Collapse Menu -->
				<li class="nav-item"><a class="nav-link collapsed" href="#"
					data-toggle="collapse" data-target="#collapseTwo"
					aria-expanded="true" aria-controls="collapseTwo"> 
					<img src="./resources/images/noun_preference.png" class="fas fa-fw"><span>Components</span>
				</a>
					<div id="collapseTwo" class="collapse" aria-labelledby="headingTwo"
						data-parent="#accordionSidebar">
						<div class="bg-white py-2 collapse-inner rounded">
							<h6 class="collapse-header">Custom Components:</h6>
							<a class="collapse-item" href="buttons.html">버전 1.0</a> <a
								class="collapse-item" href="cards.html">사용법</a>
						</div>
					</div></li>
	
				<!-- Divider -->
				<hr class="sidebar-divider d-none d-md-block">
	
				<!-- Sidebar Toggler (Sidebar) -->
				<div class="text-center d-none d-md-inline">
					<button class="rounded-circle border-0" id="sidebarToggle"></button>
				</div>
	
			</ul>
			<!-- End of Sidebar -->
	
			<!-- Content Wrapper -->
			<div id="content-wrapper" class="d-flex flex-column">
	
				<!-- Main Content -->
				<div id="content">
	
					<!-- Topbar -->
					<nav
						class="navbar navbar-expand navbar-light bg-white topbar mb-2 static-top shadow">
	
						<!-- Sidebar Toggle (Topbar) d-md-none -->
						<button id="sidebarToggleTop"
							class="btn btn-link rounded-circle mr-3">
							<i class="fa fa-bars"></i>
						</button>
						
						<div style="margin-left:1rem; ">
							<h3 class="h3 font-weight-bold" style="margin-bottom:0rem !important; margin-top:0rem !important;"> Violence </h3>
						</div>
	
					</nav>
					<!-- End of Topbar -->
	
					<!-- Begin Page Content -->
					<div class="container-fluid">
	
						<!-- Page Heading -->
						<!-- <h1 class="h3 mb-4 text-gray-800">Blank Page</h1> -->

						<c:forEach var="n" items="${memberList2}" >
							<c:if test="${n.is_criminal == 1}">
								<!-- Brand Buttons -->
		              			<div class="card shadow mb-4">
		                			<div class="card-header py-3" style="padding-bottom:0.5rem !important; padding-top:0.5rem !important">
		                  				<a class="m-0 font-weight-bold text-primary" style="width:80%" href="http://newsis.com${n.link}">${n.headline}
		                  					<p style="float:right; margin-bottom:0rem !important;">${n.date}</p>
		                  				</a>
		                			</div>
		               				<div class="card-body" style="padding: 0.5rem 1.25rem 0.5rem 1.25rem !important;">
		                  				<p style="margin-bottom: 0rem !important;">${n.message}</p>
									</div>
								</div>
							</c:if>
						</c:forEach>
					<!-- /.container-fluid -->
	
				</div>
				<!-- End of Main Content -->
	
	
			</div>
			<!-- End of Content Wrapper -->

	</div>
	<!-- End of Page Wrapper -->
	
		<!-- Bootstrap core JavaScript-->
		<script src="resources/assets/vendor/jquery/jquery.min.js"></script>
		<script
			src="resources/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
	
		<!-- Core plugin JavaScript-->
		<script
			src="resources/assets/vendor/jquery-easing/jquery.easing.min.js"></script>
	
		<!-- Custom scripts for all pages-->
		<script src="resources/assets/js/sb-admin-2.min.js"></script>
	</body>
</html>