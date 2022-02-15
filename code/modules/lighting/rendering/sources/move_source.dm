/datum/controller/subsystem/lighting/proc/move_source(datum/light_source/source, atom/oldLoc)
	//Move the source
	if(source.tile_coordinates.len)
		var/list/temp = source.tile_coordinates
		var/list/cl = list(source.z, source.x, source.y)
		LAZYREMOVE(SSlighting.light_source_grid[temp[1]][temp[2]][temp[3]][LIGHT_SOURCE], source)
		LAZYADD(SSlighting.light_source_grid[source.z][source.x][source.y][LIGHT_SOURCE], source)
		for(var/i in 1 to length(cl))
			source.tile_coordinates[i] = cl[i]
		//Update exposed tiles so that people can see lights that moved into view
		_update_tile_coordinates(source, oldLoc)

//Calculate the tiles that were exposed and now arent
//remove them from the thing
//anyone who can't see the light now can stop viewing it
/datum/controller/subsystem/lighting/proc/_update_tile_coordinates(datum/light_source/source, atom/oldLoc)
	//We loop trough the exposed grid positions saved in the light source to remove any possible
	var/list/temp = source.tile_coordinates
	for(var/i = 4, i <= length(temp), i += 3)	//is this fucky yes but maybe better than creating and destroying lists every time dunno
		LAZYREMOVE(SSlighting.light_source_grid[temp[i]][temp[i+1]][temp[i+2]][LIGHT_EXPOSED], source)
				//var/turf/T = locate(x, y, oldLoc.z);T.color=null
				//Any viewers on the tile exposed to light now needs to see this light
		for(var/viewer in SSlighting.light_source_grid[temp[i]][temp[i+1]][temp[i+2]][LIGHT_VIEWER])
			stop_viewing_source(viewer, source)
	source.tile_coordinates.len = 3
	//We can reuse this since the loc is fine
	if(source.x && source.y && source.z)
		_intial_source_setup(source)
