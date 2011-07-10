%% Miss Spawnfest 2011.

{scene, [
	{wait, 10},
	{spawn, basic, {480, 270}, [
		{var, w, 31},
		{var, x, 0.0},

		%% Pattern 1 part 1 - fixed.
		{repeat, 30, [
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
		{repeat, 2, [
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

		%% Pattern 2 - more bullet sources; different bullets; circles.
		{var, i, 45},
		{var, n, 4},
		{repeat, 4, [
			{wait, 60},
			{fire, huge, [
				{dir, i},
				{speed, 2.0},
				{repeat, 10, [
					{fire, basic, [
						{var, j, 180},
						{var, j, add, i},
						{dir, j},
						{speed, 10.0}
					]},
					{wait, 6}
				]},
				{speed, 0.0},
				{var, w, 60},
				{var, w, mul, n},
				{wait, w},
				{var, d, 90},
				{var, n, add, -4},
				{var, n, mul, -1},
				{var, d, mul, n},
				{var, d, add, -225},
				{dir, d},
				{speed, 3.0},
				{repeat, 120, [
					{var, d, add, 3},
					{dir, d},
					{wait, 1}
				]},
				{repeat, 120, [
					{fire, basic, [
					]},
					{repeat, 3, [
						{var, d, add, 3},
						{dir, d},
						{wait, 1}
					]}
				]},
				{repeat, 120, [
					{fire, basic, [
					]},
					{var, d2, 180},
					{var, d2, add, d},
					{fire, basic, [
						{dir, d2}
					]},
					{repeat, 3, [
						{var, d, add, 3},
						{dir, d},
						{wait, 1}
					]}
				]},
				{repeat, 120, [
					{fire, basic, [
					]},
					{var, d2, 180},
					{var, d2, add, d},
					{fire, basic, [
						{dir, d2}
					]},
					{repeat, 2, [
						{var, d, add, 3},
						{dir, d},
						{wait, 1}
					]}
				]},
				{repeat, 120, [
					{fire, basic, [
					]},
					{var, d2, 180},
					{var, d2, add, d},
					{fire, basic, [
						{dir, d2}
					]},
					{var, d, add, 3},
					{dir, d},
					{wait, 1}
				]},
				{wait, 240},
				finish
			]},
			{var, i, add, 90},
			{var, n, add, -1}
		]},

		vanish
	]}
]}.
