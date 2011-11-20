

import gmap


@client
callback(lat,lng,x,y) = jlog("{lat} {lng} {x} {y}")

main() = 
    conf = {
        map={
            id = "map_canvas"
            size = {width={px=500} height={px=500}}
            center = {lat=41.850033 lng=-87.6500523}
        }
        markers = [{
            position={lat=41.850033 lng=-87.6500523}
            title="Chicago"
            draggable=true
            listeners=[{
                eventname="dragend"
                callback=callback
            }]
        }]
    }
    /*<div id=#test onready={_-> Dom.transform([#test <-
    Gmap.xhtml(conf)])}></div>*/
    Gmap.xhtml(conf)

server = Server.simple_dispatch(| {~path ...} -> Resource.full_page(
       "Gmap", 
       main(), 
       <script src="http://maps.googleapis.com/maps/api/js?sensor=false"/>
       <style type="text/css">
           html, body \{
           margin: 0;
           padding: 0;
           height: 100%;
           }
       </style>, 
       {success}, []))
