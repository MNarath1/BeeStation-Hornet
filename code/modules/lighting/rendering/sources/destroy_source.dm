
#define GET_CLAMPED_DELTA(start, offset, limit) CLAMP(start - offset, 1, limit) to CLAMP(start + offset, 1, limit)

/datum/controller/subsystem/lighting/proc/destroy_source(datum/light_source/source)
	//Lighting is not initialized yet
	if(!SSlighting.initialized)
		_defer_source_deletion(source)
		return
	//Add the light source to the light sources list
	SSlighting.light_sources -= source
	if(source.z && source.y && source.x)
		//Add the source to the lighting grid
		LAZYREMOVE(SSlighting.light_source_grid[source.z][source.x][source.y][LIGHT_SOURCE], source)
		//Set up the exposed point grid
		_source_destroy_update(source)

/datum/controller/subsystem/lighting/proc/_source_destroy_update(datum/light_source/source)
	var/list/temp = source.exposed_tiles
	for(var/i = 1, i <= length(temp), i += 3)
		LAZYREMOVE(SSlighting.light_source_grid[temp[i]][temp[i+1]][temp[i+2]][LIGHT_EXPOSED], source)
			//var/turf/T = locate(x, y, source.z);T.color=null
			//Any viewers on the tile exposed to light now needs to see this light
		for(var/viewer in SSlighting.light_source_grid[temp[i]][temp[i+1]][temp[i+2]][LIGHT_VIEWER])
			stop_viewing_source(viewer, source)
	source.exposed_tiles = null

/datum/controller/subsystem/lighting/proc/_defer_source_deletion(datum/light_source/source)
	deferred_events[LIGHT_DEFER_DESTROY] += source

#undef GET_CLAMPED_DELTA
