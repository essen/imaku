%% Miss Spawnfest 2011.

	%~ {spawn, Bullet, X, Y, ActionList}
%~ {fire, Bullet, ActionList}
	%~ {wait, N}
	%~ vanish
	%~ {repeat, N, ActionList}

	%~ {dir, Dir} {dir, VarName}
	%~ {speed, Speed} {speed, VarName}
%~ {accel, X, Y}

	%~ {var, Name, Value}
	%~ {var, Name, add, Value}

{scene, [
	{wait, 10},
	{spawn, basic, {480, 270}, [
		{var, w, 50},
		{var, x, 0.0},

		%% Pattern 1 part 1 - fixed.
		{repeat, 40, [
			{repeat, 18, [
				{fire, basic, [
					{speed, 2.0},
					{dir, x}
				]},
				{var, x, add, 30}
			]},
			{wait, w},
			{var, w, add, -1}
		]},

		{var, y, 31.5},
		{var, z, -3.0},

		%% Pattern 1 part 2 - variable.
		{repeat, 3, [
			{repeat, 21, [
				{repeat, 18, [
					{fire, basic, [
						{speed, 2.0},
						{dir, x}
					]},
					{var, x, add, y},
					{wait, 1}
				]},
				{var, y, add, z}
			]},
			{var, z, mul, -1}
		]},
		vanish
	]}
]}.
