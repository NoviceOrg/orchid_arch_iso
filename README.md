# Orchid Open Source Project

Arch web-based operating system targetted for novice users offering a better yet familiar experience\
Source code forked and based on [archiso](https://github.com/archlinux/archiso)

It's powered with Arch Linux and uses Chromium (Electron) for forming the UI and some Orchid middleware like a web server, API set and services

## References

Orchid Open Source is a different kind of open source. Expect quality and polish but also expect basic human decency with our guidelines here and ACTUAL equality and fair treatment. We manually verify and pick moderators so you can't just decide to be a moderator and expect us to let you abuse your power. You need complete official verification and approval

Parental Control is a child safety feature made for hiding inappropriate or toxic content or reporting suspected predatory responses with the choice to block specific apps and optional profanity blocking toggle and a safe usage time limit because apparently there's a lack of good parenting nowadays

## Licenses

Arch Linux - [CC-BY-SA](https://terms.archlinux.org/docs/trademark-policy/)\
Orchid, It's software, services, and media - [GPL 2.0](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)\
Orchid Service Core - [Apache 2.0](https://www.apache.org/licenses/LICENSE-2.0)

## Building

To build an ISO. Execute this command:
```sh
./archiso/mkarchiso -v configs/orchid
```
- `./archiso/mkarchiso` - Path of [archiso](https://github.com/archlinux/archiso) build command line
- `-v` - Enables verbosity
- `configs/orchid` - Specified profile config path

To emulate through QEMU KVM virtualization. Execute this command:
```sh
./scripts/run_archiso.sh
```
- `./scripts/run_archiso.sh` - Path of [archiso](https://github.com/archlinux/archiso) run command line

## Contribution

You can commit changes to this repository in the form of a pull request and stage changes per feature

We won't accept changes that:
- Use any kind of random poorly built or awfully led software or library as a dependency due to:
    - Terrible quality that adds inconsistency to the quality of Orchid
    - They tend to be inferior in basically everything. Even basic things
    - We don't want to deal with a jackass irresponsible FOSS developer with the delusion that their product is perfect when we can just save time and precious brain energy replacing that developer's work. We intentionally unfavor most FOSS developers due to their lack of responsibility, sloppy experience and generally low quality effort no user wants. Oh. And them making a alternate of any existing software that does the exact same thing with no real special benefits other than a different desktop wallpaper or accent color all to fragment the FOSS space even more with the already large amounts of slop.
- Implement planned obseletion or remote control/tracking of users
- Remove any of our required medical and safety features for non-other than moronic open-source delusions
- Implement things in a terrible execution similar to most foreign distros and Capyloon that's difficult for the user to understand or use safely

## Donate To Us

Sorry but you can't at this moment. We are not greedy or plan to be greedy so we only accept donations if we plan to actually use them to improve our products for you

Know that users are our main priority and we will always take care of them and we cannot be bribed to change that
