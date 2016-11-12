(
var noteon,
    out,
    bpm = 500,
    numberOfNotes = 200,
    currentNote = 0,
    chosenNote,
    octave = 6,
    transpose = 1,
    duration = 60/bpm,
    notedict = ();
m = SimpleMIDIFile.read( "/path/to/midi.mid" ); // create empty file
out = SimpleMIDIFile("./output.mid");
out.init0( bpm );
out.timeMode = \seconds;

noteon = m.noteOnEvents(0,1);

// keep only note values in the array
noteon = noteon.flop[4];

// apply mod 12 to all the array
noteon = noteon % 12;

// For this particular midi files, noteoff are encoded as a noteon with velocity 0, remove duplications
noteon = noteon.clump(2);
noteon = noteon.flop[1];

// At this point, we have a list of midi notes from 0-12
// Let's turn that into a dictionary
notedict = notedict.putPairs([0, [], 1, [], 2, [], 3, [], 4, [], 5, [],
	                          6, [], 7, [], 8, [], 9, [], 10, [], 11, []]);

noteon.doAdjacentPairs({ arg a, b; notedict[a] = notedict[a].add(b); });

((0,(duration)..(duration*numberOfNotes))).do({
	|starttime|
	chosenNote = notedict[currentNote].choose;
	out.addNote( (chosenNote+transpose) + (12*octave), 64 + 64.rand, starttime,
		duration, 127);
	currentNote = chosenNote;
});

out.p.play;
//out.midiEvents.dopostln;
out.write;
)
