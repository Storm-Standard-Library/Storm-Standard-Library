# Storm Standard Library

The **Storm** standard library aims to unify and streamline the way Lua scripts are written for Stormworks by offering a broad set of functions covering most common tasks, and by introducing standards. Developed together with recognizable personas from Stormworks Official's \#lua channel.

The Library aims to be a framework, providing general purpose utilities as well as canvas, state machines, case, logic and control schemes, packaged in the best possible balance between performance and compact char count.

The goal is to set standards and be the baseline other libraries will follow in syntax, and to set solid grounds to start new projects from.

---

## Features
**Zero-cost availability**
Usage of advanced LifeboatAPI redundancy-remover @sections allow aggressive minifying. Having this library available but unused should not cost a single minified char. Using just a few functions should be very cheap in terms of chars after minifying.

**Compactness**
When char count is a bigger concern, functions marked with "S" for "Small" may be provided to allow further minimizing the size of built projects.

**Performance**
A set of quick functions (marked with "Q") is to be provided to let performance heavy projects proceed.

**Usability**
Being designed with input from a plethora of Lua-powerusers, the library is to be nice to use for a wide range of users.

**Versatility**
For complex tasks, multiple approaches (space-efficient, compute-efficient, general-purpose) may be present, clearly marked for easy selection.

**Standardization**
Consistent naming conventions and documentation together with a set syntax to set standards with the aim of making code more readable.

---

## Usage

1. Download the library.
2. Install [NameousChangey's LifeBoatAPI extension](https://marketplace.visualstudio.com/items?itemName=NameousChangey.lifeboatapi) in VSCode.
3. Place `StormSL` where your Lua scripts can access it as per LifeBoatAPI's instructions.
4. In your script, add:
	```lua
	require("StormSL")
	```
5. Once required, you can utilize the various modules. For example: *(be aware that exact syntax is undecided)*
	```lua
	-- Clamps a number from 0 to 255 using the clamp utility
	local clampedValue = StormSL.SLclamp(input.getNumber(1), 0, 255)
	```

---

## Contributing

We welcome community contributions under the guidelines of the GNU GPLv3 license. Currently, the founding team consists of only two members, but many well-known personas have shown interest in joining the quest, and we hope many contributors take interest in this ambitious project. As such, the homepage may change rapidly in the first days from launch.

If you would like to contribute:

1. **Fork** this repository.
2. Create a **feature branch** from `main`.
3. **Commit** your changes with clear, concise messages.
4. **Open a Pull Request**, linking to any relevant issues.

We welcome feature requests, bug reports or notes about our project in GitHub Issues and Discussions, where most of our coordination is to take place.
Feel free to socialize and daydream in our [discord](https://discord.gg/2GMG4Jt5ds)

---

## Closing notes

### License
This project is licensed under the [GNU General Public License v3.0](LICENSE.md). You are free to modify, distribute, and use the software under the terms of this license.

### Project Status

- Alpha, `0.0.0`
- Actively in initial development and design phases.

### Roadmap

- nil
- nada
- null
- none

### Changelog

[You can view our progress by clicking here](CHANGELOG.md)

---

*Thank you for checking out the Storm Standard Library! We look forward to your contributions and feedback.*
