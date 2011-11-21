

import gmap


@client
callback(lat,lng,_x,_y) =
    Dom.transform([#lat <- <>{lat}</>, #lng <- <>{lng}</>])

main() = 
    do Gmap.init()
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
    map = Gmap.xhtml(conf)
    <div>latitude : <span id=#lat></span><br/>longitude : <span id=#lng></span></div>
    <div>{map}</div>

server = Server.simple_dispatch(| {~path ...} -> Resource.full_page(
       "Gmap", 
       main(), 
       <style type="text/css">
           html, body \{
           margin: 0;
           padding: 0;
           height: 100%;
           }
       </style>, 
       {success}, []))
