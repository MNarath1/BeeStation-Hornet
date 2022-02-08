#define GET_CLAMPED_DELTA(start, offset, limit) CLAMP(start - offset, 1, limit) to CLAMP(start + offset, 1, limit)

/datum/controller/subsystem/lighting/proc/move_source(datum/light_source/source, atom/oldLoc)
	//Move the source
	if(oldLoc.z && oldLoc.x && oldLoc.y)
		LAZYREMOVE(SSlighting.light_source_grid[oldLoc.z][oldLoc.x][oldLoc.y][LIGHT_SOURCE], source)
	if(source.x && source.y && source.z)
		LAZYADD(SSlighting.light_source_grid[source.z][source.x][source.y][LIGHT_SOURCE], source)
	//Update exposed tiles so that people can see lights that moved into view
	_update_exposed_tiles(source, oldLoc)

//Calculate the tiles that were exposed and now arent
//remove them from the thing
//anyone who can't see the light now can stop viewing it
/datum/controller/subsystem/lighting/proc/_update_exposed_tiles(datum/light_source/source, atom/oldLoc)
	//We loop trough the exposed grid positions saved in the light source to remove any possible
	for(var/list/l in source.exposed_tiles)
		LAZYREMOVE(SSlighting.light_source_grid[l[1]][l[2]][l[3]][LIGHT_EXPOSED], source)
				//var/turf/T = locate(x, y, oldLoc.z);T.color=null
				//Any viewers on the tile exposed to light now needs to see this light
		for(var/viewer in SSlighting.light_source_grid[l[1]][l[2]][l[3]][LIGHT_VIEWER])
			stop_viewing_source(viewer, source)
		LAZYREMOVE(source.exposed_tiles, l)
	//We can reuse this since the loc is fine
	if(source.x && source.y && source.z)
		_intial_source_setup(source)

#undef GET_CLAMPED_DELTA
