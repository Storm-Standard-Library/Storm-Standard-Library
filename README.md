# Storm Standard Library

The **Storm Standard Library** is designed to unify and streamline Lua scripting for Stormworks, by providing a comprehensive set of functions for common tasks, and by establishing clear standards. Created by and with input from experienced Lua developers.

The library's primary function is providing general purpose un-opinionated utilities, but it should not shy away from more general functionality, such as state machines, case, logic, canvas, and control schemes, all packaged in the best possible balance between performance and compact char count.

The goal is to set standards and be the baseline other libraries will follow in syntax, and to set solid grounds to start new projects from.

---

## Features
**Zero-cost presence**
Usage of advanced LifeboatAPI redundancy-remover sections allows aggressive minifying. You shouldn't pay in chars for anything in the library that you don't use. That means if you import but don't use the library, it shouldn't cost you a single char.

**Performance**
All functions are to be reasonably optimized, but for the times when it is desireable to trade character count for execution speed, alternative functions (marked with 'Q' for 'Quick') may be provided.

**Compactness**
All functions are to be implemented with reasonably few characters, but as with performance, an extra set (marked with 'S' for 'Small') that trades speed for characters may be provided.

**Usability**
Being designed with input from a plethora of experienced Lua-coders, the library should respect usability for a broad, capable audience.

**Standardization**
Consistent naming conventions, documentation, testing, and syntax, sets standards with the aim of improving code quality.

---

## Usage

1. Download the library.
2. Install [NameousChangey's LifeBoatAPI extension](https://marketplace.visualstudio.com/items?itemName=NameousChangey.lifeboatapi) in VSCode.
3. Place `StormSL` where your Lua scripts can access it as per LifeBoatAPI's instructions.
4. In your script, add:
	```lua
	require("StormSL")
	```
5. Once required, you can utilize the various modules. For example: *(exact syntax is undecided as of writing)*
	```lua
	-- Clamps a number from 0 to 255 using the clamp utility
	local clampedValue = StormSL.SLclamp(input.getNumber(1), 0, 255)
	```

---

## Contributing

Community contributions are very welcome under the guidelines of the GNU GPLv3 license. Currently, the founding team consists of only two members, but many well-known personas have shown interest, and we hope many contributors take interest in this ambitious project. As such, it may change rapidly in the first period from launch.

If you have notice anything that you believe is a bug, please make us aware by creating an issue using the "Bug report" issue template.

If you would like to see a change implemented, or feature added, please make an issue using the "Feature request" template.

If you yourself would like to contribute:

1. **Fork** this repository.
2. Create a **feature branch** from `dev`.
3. Roughly follow the coding style you see in the rest of the project, and **Commit** your changes with clear, concise messages.
4. Open a **Pull Request**, and if applicable, **link** to relevant issues.

See **Repository structure** below. We welcome feature requests, bug reports or notes about our project in GitHub Issues and Discussions, where most of our coordination is to take place.
Feel free to socialize and daydream in our [**discord**](https://discord.gg/2GMG4Jt5ds)
If you have any questions, feel free to ask in GitHub Discussions or in the discord!

---

## Repository structure

The repository is to be structured as follows:
- `main` branch. Holds stable and test-passing, usable versions. Commits and merges into `main` should require review.
- `dev` branch. May not always be fully usable or test-passing. Work of small scope can be done here when appropriate, but entire additions or changes should be done in feature/change-branches. It should be merged into `main` when it makes sense to, e.g. when a new set of functions and their tests are done. Commits and merges into `dev` should require review.
- `feature/change` branches. These are where the brunt of changes and additions should be performed. They are to be created as needed, and merged into `dev` once their purpose is fulfilled, after which they can be destroyed. Commits and merges into these branches should not require review.

Shoddy paint illustration below:
![image](/Images/repo.png)

---

## Closing notes

### License
This project is licensed under the [GNU General Public License v3.0](LICENSE). You are free to modify, distribute, and use the software under the terms of this license.

### Project Status

- Alpha, `0.0.0`
- Actively in initial development and design phases.

### Changelog

[You can view our progress by clicking here](CHANGELOG.md)

---

*Thank you for checking out the Storm Standard Library, we look forward to your contributions and feedback.*
