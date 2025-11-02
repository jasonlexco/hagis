<!DOCTYPE html>
<html>
    <head>
		<meta charset="utf-8" />
        <title>OpenLayers Sample using Topographic Map and Label Map APIs</title>
        <script src="https://cdn.jsdelivr.net/npm/ol@v10.2.1/dist/ol.js"></script>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/ol@v10.2.1/ol.css">
        <style>
            html,body,#map{
                padding:0 0;
                margin:0 0;
                width:100%;
                height:100%;
            }
            .ol-attribution.ol-uncollapsible {
                bottom: 12px;
                background: transparent
            }
			.ol-attribution ul {
				font-size: 12px;
				font-family: sans-serif;
			}
			.ol-attribution a {
                color: black;
            }
			.copyrightDiv {
				display: inline-block;
				height: 1rem;
				line-height: 1rem;
				position: absolute;
				top: 50%;
				bottom: 5px;
				right:  40px;
				margin: 0 5px 0 0;
				padding: 0 4px;
				font-family:  sans-serif;
				font-size: 12px;
				background-color: rgba( 255, 255, 255, 0.7 );
				color: #333;
				text-align: left;
				text-overflow: ellipsis;
				white-space: nowrap;
				z-index: 1;
			}             
        </style>
    </head>
    <body>
        <div id="map" class="map"></div>
        <script>
		
        // Get parameters x and y from the URL using JSP
        var e = '<%= request.getParameter("x") != null ? request.getParameter("e") : "defaultX" %>';
        var n = '<%= request.getParameter("y") != null ? request.getParameter("n") : "defaultY" %>';
		//console.log("N: ", n);
		//console.log("E: ", e);
        // Example WKT point using x and y parameters
        //var wkt = 'POINT (' + e + ' ' + n+ ')';
		var wkt = 'POINT (' + e + ' ' + n + ')';
        //console.log("WKT Point: ", wkt);
			var format = new ol.format.WKT();
			var feature = format.readFeature(wkt, {
			  dataProjection: 'EPSG:4326',
			  featureProjection: 'EPSG:3857',
			});
			var vector = new ol.layer.Vector({
			  source: new ol.source.Vector({
				features: [feature],
			  }),
			});
			vector.setStyle(new ol.style.Style({
				image: new ol.style.Circle({
				  radius: 6,
				  fill: new ol.style.Fill({
					color: 'red'
				  })
				})
			}));
			const geometry = feature.getGeometry();
			const extent = geometry.getExtent();
			const center = ol.extent.getCenter(extent);
		
		
			var basemapAPI = 'https://mapapi.geodata.gov.hk/gs/api/v1.0.0/xyz/basemap/wgs84/{z}/{x}/{y}.png';
			var labelAPI = 'https://mapapi.geodata.gov.hk/gs/api/v1.0.0/xyz/label/hk/tc/wgs84/{z}/{x}/{y}.png';
			var attributionInfo = '<a href="https://api.portal.hkmapservice.gov.hk/disclaimer" target="_blank" class="copyrightDiv">&copy; Map infortmation from Lands Department</a><div style="width:28px;height:28px;display:inline-flex;background:url(https://api.hkmapservice.gov.hk/mapapi/landsdlogo.jpg);background-size:28px;"></div>';
      		var attribution = new ol.control.Attribution({
        		collapsible: false            
      		});          
            var map = new ol.Map({
        		controls: ol.control.defaults.defaults({attribution: false}).extend([new ol.control.Attribution({collapsible: false})]),     			
                layers: [
                    new ol.layer.Tile({
                        source: new ol.source.XYZ({
                            url: basemapAPI,
							attributions: attributionInfo			
                        })
                    }),
                    new ol.layer.Tile({
                        source: new ol.source.XYZ({
                            url: labelAPI
                        })
                    }), vector
                ],
                target: 'map',
				logo: false,
                view: new ol.View({
                  // center: ol.proj.fromLonLat([114.20847, 22.29227]),
					center: center,
                    zoom: 20,
                    minZoom: 10,
                    maxZoom: 20
                })
            });
        </script>
    </body>
</html>

