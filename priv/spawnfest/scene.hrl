%% Miss Spawnfest 2011.

	%~ {spawn, Bullet, X, Y, ActionList}
%~ {fire, Bullet, ActionList}
	%~ {wait, N}
	%~ vanish
	%~ {repeat, N, ActionList}

	%~ {dir, Dir}
	%~ {speed, Speed}
%~ {accel, X, Y}

	%~ {var, Name, Value}
	%~ {var, Name, add, Value}

{scene, [
	{wait, 10},
	{spawn, basic, {480.0, 270.0}, [
		%~ {speed, 1.0},
		{var, x, 0},
		{repeat, 100, [
			{repeat, 18, [
				{fire, basic, [
					{speed, 2.0},
					{dir, x}
				]},
				{var, x, add, 20},
				{wait, 1}
			]}
		]}
	]}
]}.
