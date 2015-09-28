1::second => dur beat;
Machine.add(me.dir()+"/glissons") => int fileID;
while( true )
{

    // Cambia dentro de las comillas el archivos que quieres que
    // quede en loop, al salvar se actualiza con cada 8 beats.
    beat * 8 => now;
    if(Machine.replace( fileID, me.dir() + "/glissons") == true)
	{
	    Machine.remove( fileID );
	    Machine.add(me.dir()+"/glissons") => int fileID; // and problem solved
	}

}
