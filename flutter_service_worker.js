'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"version.json": "00e7c0a2baba374dcf9baa070f588033",
"index.html": "0947ac005b16b855e415fb1582596edb",
"/": "0947ac005b16b855e415fb1582596edb",
"main.dart.js": "dc8c745f140256de85e413585a193912",
"flutter.js": "6fef97aeca90b426343ba6c5c9dc5d4a",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "935f442f83bf4284b88fbf295849c325",
"assets/AssetManifest.json": "f0165ffb3e8028c7c722d18ce15b4d54",
"assets/NOTICES": "4abdebf9201dcd4107e106db53f0d280",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "89ed8f4e49bcdfc0b5bfc9b24591e347",
"assets/packages/icony/assets/images/icony_ikonate/grid.svg": "1cbfc50c1e46268443704ba7e714173d",
"assets/packages/icony/assets/images/icony_ikonate/search.svg": "df8e0f8fe10f4012a8840ed6e0c1e4cb",
"assets/packages/icony/assets/images/icony_ikonate/grid-alt.svg": "4d9254f24d5e7650725de7c996f0303e",
"assets/packages/icony/assets/images/icony_ikonate/origin.svg": "9a730bee8bae0b20ddfecfbc45e47835",
"assets/packages/icony/assets/images/icony_ikonate/arrow-up-circle.svg": "a772133461f07147a108bcd6bc4fd3a8",
"assets/packages/icony/assets/images/icony_ikonate/cart-add.svg": "b7d92fec4034d2d21110b5ed06383615",
"assets/packages/icony/assets/images/icony_ikonate/wine.svg": "1afc4c18a640b9a8515fd042e8b051a2",
"assets/packages/icony/assets/images/icony_ikonate/suitcase-alt.svg": "d5e89f831106131116708bb296a6de43",
"assets/packages/icony/assets/images/icony_ikonate/pause-circle.svg": "9bddec33909538ca21c22a94120a6afc",
"assets/packages/icony/assets/images/icony_ikonate/arrow-down.svg": "978408e69289947173582594810207c5",
"assets/packages/icony/assets/images/icony_ikonate/chevrons-right.svg": "6ff37a6c9f85ffe0f4156e5662391363",
"assets/packages/icony/assets/images/icony_ikonate/list.svg": "d4aaa65cd82acf4dbb38b886a2f145b5",
"assets/packages/icony/assets/images/icony_ikonate/next-alt.svg": "03f0d517fd67726dc660a0053f8ca146",
"assets/packages/icony/assets/images/icony_ikonate/volume-off.svg": "e3bb6a13eb8fd3ce13a9dfd7a1d4f4e5",
"assets/packages/icony/assets/images/icony_ikonate/stats-alt.svg": "2425498b0fba2d76366de85e291e1f2b",
"assets/packages/icony/assets/images/icony_ikonate/eye-crossed.svg": "368b58d119cdb74c0ce692c73651b155",
"assets/packages/icony/assets/images/icony_ikonate/chevrons-down.svg": "69ed9a97ba058c7c82d62898c30ccc26",
"assets/packages/icony/assets/images/icony_ikonate/calendar-decline.svg": "3e0b9a0750e8e24dc0bbfb83e26030ac",
"assets/packages/icony/assets/images/icony_ikonate/directions-left.svg": "4d4d27f2246549a703587e7aff53982f",
"assets/packages/icony/assets/images/icony_ikonate/direction-left.svg": "fd46aaaff483226bb27f54eed6f7192f",
"assets/packages/icony/assets/images/icony_ikonate/list-alt.svg": "1ee1ef1a3209942e5925815c9ac4ba3a",
"assets/packages/icony/assets/images/icony_ikonate/fit.svg": "fff4c5f9fc7b8dd978fa93b584354915",
"assets/packages/icony/assets/images/icony_ikonate/ellypsis-vertical.svg": "ba5f8742cc87a8bc2fd48123cddb851f",
"assets/packages/icony/assets/images/icony_ikonate/repeat.svg": "698e8c3a1034fa3e304fdd9ebcc4e288",
"assets/packages/icony/assets/images/icony_ikonate/hourglass.svg": "b13b1dd7b1b54bf09222b6bebc0eb871",
"assets/packages/icony/assets/images/icony_ikonate/clip.svg": "e5dbb327330a65e34434b1fed43eded6",
"assets/packages/icony/assets/images/icony_ikonate/entrance.svg": "9d21050e0a6eed0840239256a687c3ce",
"assets/packages/icony/assets/images/icony_ikonate/chart.svg": "eaa22b61c0bf42072d9249d6865f9d21",
"assets/packages/icony/assets/images/icony_ikonate/neutral-face.svg": "20ef3cefdb0850b4f0d97fa264455b9e",
"assets/packages/icony/assets/images/icony_ikonate/hamburger.svg": "0294b9fae43859b1fbf32ffe18ada2ea",
"assets/packages/icony/assets/images/icony_ikonate/snow.svg": "d2fdfd28bd0483372f09815d813bdc37",
"assets/packages/icony/assets/images/icony_ikonate/thumb-up.svg": "cd0d860d573b46e6a569c4190cbec734",
"assets/packages/icony/assets/images/icony_ikonate/umbrella.svg": "0a2a00570d73d9a2dfaba6eb04bd62d2",
"assets/packages/icony/assets/images/icony_ikonate/user.svg": "94f990fe59db9716deae803b5f4d2af0",
"assets/packages/icony/assets/images/icony_ikonate/shift.svg": "024759d6fbf77d0840f2b62b64e7baf6",
"assets/packages/icony/assets/images/icony_ikonate/restaurant.svg": "b0f19859a94e2b1e001a7f775a7636c8",
"assets/packages/icony/assets/images/icony_ikonate/circle.svg": "44c513045443dad06aba1de5b500b4a3",
"assets/packages/icony/assets/images/icony_ikonate/rectangle.svg": "e2a3b606094eb36d703455e800f9dc03",
"assets/packages/icony/assets/images/icony_ikonate/radio-button.svg": "29fb6d811c5a14a19a5628b3e5921309",
"assets/packages/icony/assets/images/icony_ikonate/person.svg": "051793cad6b76614b6c36fed7cfce9b6",
"assets/packages/icony/assets/images/icony_ikonate/home.svg": "90018de628294629dfef82ed9d4fd9ba",
"assets/packages/icony/assets/images/icony_ikonate/music.svg": "0f8e02a7fa11f3edd9690169819f2fd8",
"assets/packages/icony/assets/images/icony_ikonate/smartphone.svg": "1a91d182a237e3f5341484fc1c192b5a",
"assets/packages/icony/assets/images/icony_ikonate/control-centre.svg": "96352449f14245be5674e464fd5207c9",
"assets/packages/icony/assets/images/icony_ikonate/chevron-down.svg": "f0cb6f1d6ff9267cddb0a6dda75c33f7",
"assets/packages/icony/assets/images/icony_ikonate/envelope-alt.svg": "281494014443b82401abad226d250551",
"assets/packages/icony/assets/images/icony_ikonate/ellypsis.svg": "47a233aaa6e31323ade10f2c833a47ce",
"assets/packages/icony/assets/images/icony_ikonate/favourite.svg": "3e27175845c775ec201fb2708630b1c6",
"assets/packages/icony/assets/images/icony_ikonate/celluar.svg": "f351e098b9e039f336d290e55f97798d",
"assets/packages/icony/assets/images/icony_ikonate/code-alt.svg": "3085f6d74fb32dd246456942cf8d549b",
"assets/packages/icony/assets/images/icony_ikonate/box-alt.svg": "170b727aaa9d0e0ed6f34454b8d4f568",
"assets/packages/icony/assets/images/icony_ikonate/sorting.svg": "afabe5f208d8ddbda6352fa2a1e1e83a",
"assets/packages/icony/assets/images/icony_ikonate/cancel.svg": "fd7a9f72461c7634034f51cd3d15a8eb",
"assets/packages/icony/assets/images/icony_ikonate/rotate.svg": "0e7964233d0237ecadec5ed834e1501e",
"assets/packages/icony/assets/images/icony_ikonate/crop.svg": "eafffac48d106a21ae4629305b264dad",
"assets/packages/icony/assets/images/icony_ikonate/tag.svg": "d4f0cceb52e2f9b2fac5d5f1d0cea244",
"assets/packages/icony/assets/images/icony_ikonate/presentation.svg": "c2ae4b098f393dc454d0cfeda506ee65",
"assets/packages/icony/assets/images/icony_ikonate/calendar-add.svg": "c6d3ab1ec2e811a946b3ab5d0319c21f",
"assets/packages/icony/assets/images/icony_ikonate/vertical.svg": "3468e42eeb55b1f84c0a16c71796f881",
"assets/packages/icony/assets/images/icony_ikonate/map.svg": "f79f93af5f9ea8a83e0d940500286ea8",
"assets/packages/icony/assets/images/icony_ikonate/inbox.svg": "d2460a9166a923e23fa810cbd78a7e06",
"assets/packages/icony/assets/images/icony_ikonate/power.svg": "d491ca59300738b57348384c51ddea1a",
"assets/packages/icony/assets/images/icony_ikonate/microphone.svg": "ffb30309c7da3e4aae290cbe26337ad6",
"assets/packages/icony/assets/images/icony_ikonate/verified.svg": "4fd5b9a40f9a335a133eb43e1de8f106",
"assets/packages/icony/assets/images/icony_ikonate/bike.svg": "60197459729a590c48633fb4be042dfc",
"assets/packages/icony/assets/images/icony_ikonate/file.svg": "c59e878003389c25f6c2e32629772b09",
"assets/packages/icony/assets/images/icony_ikonate/support-alt.svg": "e4e68ad01c10aae41ebf8bb25ffbabd1",
"assets/packages/icony/assets/images/icony_ikonate/no-entry.svg": "53b3c20200e16deb60e73a9cefbb87d7",
"assets/packages/icony/assets/images/icony_ikonate/signal.svg": "6cfe8149d6e3cdb7e4a984e54042ae10",
"assets/packages/icony/assets/images/icony_ikonate/folder-remove.svg": "c9f00cc1a998e3eb58e2b6776d24d180",
"assets/packages/icony/assets/images/icony_ikonate/voicemail.svg": "6bbbf91166c80b420b4b9ea54d3951ea",
"assets/packages/icony/assets/images/icony_ikonate/contrast.svg": "fef93dea68c6c3ba65d8858ca5a7083c",
"assets/packages/icony/assets/images/icony_ikonate/box-alt2.svg": "fa7af4841bde302af204990eb46308e0",
"assets/packages/icony/assets/images/icony_ikonate/chevron-up.svg": "9fcfacd05d3603beaf480ffdf8b62e2a",
"assets/packages/icony/assets/images/icony_ikonate/typography.svg": "e6c914c5503ba32199a908cb1e99dd96",
"assets/packages/icony/assets/images/icony_ikonate/signal-alt.svg": "c5f86a24e7bc8af19bcc0366e078c371",
"assets/packages/icony/assets/images/icony_ikonate/home-alt.svg": "5b88549bed86341dbd2e410304a6e703",
"assets/packages/icony/assets/images/icony_ikonate/chat-warning.svg": "e54ad33e61cba26475741dc6bb2fa724",
"assets/packages/icony/assets/images/icony_ikonate/eye-closed.svg": "f21ec6947e738f9cff88fb9ac17c5a03",
"assets/packages/icony/assets/images/icony_ikonate/lock.svg": "db0ce8a660c22b821330bfce004694cc",
"assets/packages/icony/assets/images/icony_ikonate/cloud-upload.svg": "cfe1f9d736018a7ce49f693fb4ad6a81",
"assets/packages/icony/assets/images/icony_ikonate/folder-warning.svg": "18a7da67b722da0b454cb1570b0781d9",
"assets/packages/icony/assets/images/icony_ikonate/hearing-disability.svg": "bb7de90c1f798cb4cd51a06b6ed743a1",
"assets/packages/icony/assets/images/icony_ikonate/calendar-event.svg": "47094f01c270b3689e7a16b0303258d1",
"assets/packages/icony/assets/images/icony_ikonate/pen.svg": "680d3dbca3e65694d3aea57b50bf96a3",
"assets/packages/icony/assets/images/icony_ikonate/table-horizontal.svg": "2f94e78c03c04f521985bd1e2c262718",
"assets/packages/icony/assets/images/icony_ikonate/plane.svg": "892b409721fcb58bfcaf8d2c3a812865",
"assets/packages/icony/assets/images/icony_ikonate/chevron-right.svg": "374f0c12555b5fdfe4d66d8ddc4ff150",
"assets/packages/icony/assets/images/icony_ikonate/thunder.svg": "38d402192e58afdc1da5baf550d49727",
"assets/packages/icony/assets/images/icony_ikonate/clipboard.svg": "4987e00ba961cb9c96af8f8aa9ef1da3",
"assets/packages/icony/assets/images/icony_ikonate/swap-vertical.svg": "51a16ec54474def5107898c3c798db79",
"assets/packages/icony/assets/images/icony_ikonate/swap-horizontal.svg": "683a92bff3bd6f40c4f2bb9395765a60",
"assets/packages/icony/assets/images/icony_ikonate/link.svg": "96dbb0983b3f204fb13588f8199c1cf7",
"assets/packages/icony/assets/images/icony_ikonate/key.svg": "6fd5fd59b8160403e36e6cd30ffcb8a8",
"assets/packages/icony/assets/images/icony_ikonate/turn-right.svg": "a19c83fa0f8ba48e0198a7a67e59d93e",
"assets/packages/icony/assets/images/icony_ikonate/arrow-right.svg": "322e922407a05a1e4ebebf442324aa34",
"assets/packages/icony/assets/images/icony_ikonate/aperture.svg": "c5ecab837e4235e69867a334cb107cb5",
"assets/packages/icony/assets/images/icony_ikonate/arrow-left-circle.svg": "cf43130411d86c988278f29fc982adb5",
"assets/packages/icony/assets/images/icony_ikonate/lock-alt-open.svg": "1507af6a933cc4924191bb5501bc8732",
"assets/packages/icony/assets/images/icony_ikonate/wallpaper.svg": "090baeca46afd218b84f646c962cfe60",
"assets/packages/icony/assets/images/icony_ikonate/return.svg": "9936298ee1f7ec033e20617660baf026",
"assets/packages/icony/assets/images/icony_ikonate/stopwatch.svg": "6e38de353b945a9ca3cea8cf2c1cab7c",
"assets/packages/icony/assets/images/icony_ikonate/settings.svg": "ad5ac780ffeeb3d3306c7833f88274fb",
"assets/packages/icony/assets/images/icony_ikonate/cart.svg": "99c863d60787a30c05646832daee42e8",
"assets/packages/icony/assets/images/icony_ikonate/envelope.svg": "a587adb47fc4b5b1a7f404c11cafb33e",
"assets/packages/icony/assets/images/icony_ikonate/shield.svg": "ddc2e0e71cd93e745f43804ce2237723",
"assets/packages/icony/assets/images/icony_ikonate/download.svg": "5bee97500b38c2dd6e8e401d7611c4ae",
"assets/packages/icony/assets/images/icony_ikonate/cloud-crossed.svg": "46a3d1346ffc38427dd1577b0819c321",
"assets/packages/icony/assets/images/icony_ikonate/spam.svg": "e1adcf52b71ba16abcac1cb63363068a",
"assets/packages/icony/assets/images/icony_ikonate/time.svg": "82f356eb02ac7421b1a0f7b77d7019d4",
"assets/packages/icony/assets/images/icony_ikonate/apps.svg": "b6e56bdffec19e0a9fb45565acc27553",
"assets/packages/icony/assets/images/icony_ikonate/chat-alt.svg": "3a39582e5ef77d8ddcb45cffdd6a9865",
"assets/packages/icony/assets/images/icony_ikonate/bolt.svg": "da3e54cc4b834864fbf8b97b2c691f31",
"assets/packages/icony/assets/images/icony_ikonate/tv.svg": "b29150fa48dc6398915d5e4b7cc0862b",
"assets/packages/icony/assets/images/icony_ikonate/happy-face.svg": "186d63096536586540178697cfc731ea",
"assets/packages/icony/assets/images/icony_ikonate/battery-medium.svg": "2577b4ccd228acf121ffb5b6a95be383",
"assets/packages/icony/assets/images/icony_ikonate/ok.svg": "44090536702ed237b112f81926ff81d1",
"assets/packages/icony/assets/images/icony_ikonate/battery-charging.svg": "50fca63009abdb1c0caee0f881fb9eb2",
"assets/packages/icony/assets/images/icony_ikonate/layers.svg": "bde0345ac376a09141435a9d72e45a42",
"assets/packages/icony/assets/images/icony_ikonate/radio.svg": "b22e623a4869f9671034032aaee79105",
"assets/packages/icony/assets/images/icony_ikonate/book.svg": "8d2d44807d06ab0f9a4552a1e61c976a",
"assets/packages/icony/assets/images/icony_ikonate/previous-alt.svg": "8a8729c278e77c645a2f17ca34c82878",
"assets/packages/icony/assets/images/icony_ikonate/skull.svg": "478fcff0e98568ba251df4bfe5972cbb",
"assets/packages/icony/assets/images/icony_ikonate/train.svg": "d6e18fd84f5bca93aa39f71ef13fce0b",
"assets/packages/icony/assets/images/icony_ikonate/contact-book.svg": "89c220a72932c268a67d87a491a8e607",
"assets/packages/icony/assets/images/icony_ikonate/bell.svg": "dc29c09f8eebc5a9d4177bd8e2c2109d",
"assets/packages/icony/assets/images/icony_ikonate/coffee.svg": "7d143e7bea2d881ed2f1311933195ca7",
"assets/packages/icony/assets/images/icony_ikonate/dashboard.svg": "48900b85fb2cd13bb5f6aaacece7860b",
"assets/packages/icony/assets/images/icony_ikonate/code.svg": "bee3ab19998f14270bf858c2cf9c36dd",
"assets/packages/icony/assets/images/icony_ikonate/checkbox-intermediate.svg": "e36dfcf7ac8eac721248b8ca76ed0e49",
"assets/packages/icony/assets/images/icony_ikonate/apps-alt.svg": "22baa08df790a5dbfbecf3add87e7d20",
"assets/packages/icony/assets/images/icony_ikonate/thermometer.svg": "0f0fced41b91dd135abb3d187a004e37",
"assets/packages/icony/assets/images/icony_ikonate/flag.svg": "a4f3fafc1060b4c5aab64f752cfe8be6",
"assets/packages/icony/assets/images/icony_ikonate/not-allowed.svg": "987e693dca140973b627d3dffc414f13",
"assets/packages/icony/assets/images/icony_ikonate/share-ios.svg": "35eb1bc204a9c406eae1e7b76219ddec",
"assets/packages/icony/assets/images/icony_ikonate/battery.svg": "84fa34e1f4fbedf76c8d0ecfaf407a19",
"assets/packages/icony/assets/images/icony_ikonate/stop.svg": "17580ef95874f1663cd6b674e8550b98",
"assets/packages/icony/assets/images/icony_ikonate/tag-alt.svg": "63740d10004ec0d3a2b6ac6020d4ff7e",
"assets/packages/icony/assets/images/icony_ikonate/disc.svg": "5a4947f1240033e14480286e60a4e6fe",
"assets/packages/icony/assets/images/icony_ikonate/volume-loud.svg": "c609d54b6b764fefab87c5e2bc36e96d",
"assets/packages/icony/assets/images/icony_ikonate/support.svg": "33d0f2816361bf980daa949b6afe3110",
"assets/packages/icony/assets/images/icony_ikonate/tool.svg": "e0c2d49e3156d2d8ccd0562439c60756",
"assets/packages/icony/assets/images/icony_ikonate/cursor.svg": "1d8af699be413b4cfca8586d202e258c",
"assets/packages/icony/assets/images/icony_ikonate/switch-off.svg": "0a9d491d827b5d5df2d61c454bc7679f",
"assets/packages/icony/assets/images/icony_ikonate/night-mode.svg": "bdeb451a0e5c0c3fe4fe635b27afd7bd",
"assets/packages/icony/assets/images/icony_ikonate/table-vertical.svg": "3603e6bd8e2f2e1090b30d641989bebb",
"assets/packages/icony/assets/images/icony_ikonate/hash.svg": "e08b6bf2c1536ad8c7e55231f3e56912",
"assets/packages/icony/assets/images/icony_ikonate/battery-full.svg": "e4eeecad12038dcad4d7320c1cbec783",
"assets/packages/icony/assets/images/icony_ikonate/plus.svg": "2fa6652202ed12d2a8b8ad220f15be60",
"assets/packages/icony/assets/images/icony_ikonate/feed.svg": "a6d912327eb9ea7fa03813b501c17a8c",
"assets/packages/icony/assets/images/icony_ikonate/bluetooth.svg": "7e32dff84c0715beb90c0510e71f1ff8",
"assets/packages/icony/assets/images/icony_ikonate/pie-chart.svg": "5dc0038e684c7f1bf68efa5298d24b7d",
"assets/packages/icony/assets/images/icony_ikonate/headphones.svg": "9ad3317daaa4a532d694deacf9f4f5ed",
"assets/packages/icony/assets/images/icony_ikonate/rss.svg": "e77d90463aaa365fe4aac8ca9285743e",
"assets/packages/icony/assets/images/icony_ikonate/wifi.svg": "879428bebe9459d194af99616c30a02c",
"assets/packages/icony/assets/images/icony_ikonate/watch.svg": "6ed2df457e652393162561f729d7db2a",
"assets/packages/icony/assets/images/icony_ikonate/arrow-left-bottom.svg": "2e44c9af4d991537a9668ae286a1e34c",
"assets/packages/icony/assets/images/icony_ikonate/news.svg": "2cdbc39445ed4e8e55f3f8b17ecc0589",
"assets/packages/icony/assets/images/icony_ikonate/info.svg": "eb749ad83e1cd24089c992f040758bac",
"assets/packages/icony/assets/images/icony_ikonate/add.svg": "91d6f27ba8dcf9b2494e05a4a9599537",
"assets/packages/icony/assets/images/icony_ikonate/home-alt2.svg": "370626380d5a59e584d5db989e96087a",
"assets/packages/icony/assets/images/icony_ikonate/close.svg": "6aa248fdec45600323709cd6e23872c8",
"assets/packages/icony/assets/images/icony_ikonate/people.svg": "008ccfe1b135bb5da552202df3eb15b6",
"assets/packages/icony/assets/images/icony_ikonate/dialpad.svg": "34a1ee3f3a6de77f95c4e40d074f9abb",
"assets/packages/icony/assets/images/icony_ikonate/list-view.svg": "cd98f7689b59f2850f175e27889cb515",
"assets/packages/icony/assets/images/icony_ikonate/copy.svg": "54695fd49be5e03d953c16ec6bb2ae28",
"assets/packages/icony/assets/images/icony_ikonate/zoom-in.svg": "8556328925432fb6f572d279871bdae5",
"assets/packages/icony/assets/images/icony_ikonate/back-right.svg": "b1c4212006ad49991f3d84b90d07c6e1",
"assets/packages/icony/assets/images/icony_ikonate/rain.svg": "19d3829c16737907979adbc6285a4ff7",
"assets/packages/icony/assets/images/icony_ikonate/bag.svg": "10965ff60fbbbdc8582a1bc294e72b23",
"assets/packages/icony/assets/images/icony_ikonate/glasses.svg": "e4ca8375b23a38ab8f6011a03b003b31",
"assets/packages/icony/assets/images/icony_ikonate/refresh.svg": "87cb6e3edb309c80fd349e1ed3f9bb03",
"assets/packages/icony/assets/images/icony_ikonate/accessibility-human.svg": "d00169a6de81213c21ee961547aae539",
"assets/packages/icony/assets/images/icony_ikonate/layout-right.svg": "99a52c708119b5e66596f55468fca92b",
"assets/packages/icony/assets/images/icony_ikonate/arrow-right-circle.svg": "53b117eb30d5d0b607c05e210abc1b0c",
"assets/packages/icony/assets/images/icony_ikonate/text.svg": "8d7476732ac9b584f63362c8e95012a1",
"assets/packages/icony/assets/images/icony_ikonate/maximise.svg": "b6f7489697d27cf26493fc2169b8729a",
"assets/packages/icony/assets/images/icony_ikonate/marker.svg": "9ede460eee20fe0d5afa32cad5a6292e",
"assets/packages/icony/assets/images/icony_ikonate/align-right.svg": "bbe01759359751993e028a1708533ffc",
"assets/packages/icony/assets/images/icony_ikonate/image.svg": "3524d6a6382d12c19ccb4afeb86d1b79",
"assets/packages/icony/assets/images/icony_ikonate/lightbulb.svg": "96af83d30221a20a7bf753a00691eda4",
"assets/packages/icony/assets/images/icony_ikonate/thumb-down.svg": "e199992a9583ed77142d346613d0defe",
"assets/packages/icony/assets/images/icony_ikonate/sunset.svg": "c08ab5629737f8c6422bcd0a055a166c",
"assets/packages/icony/assets/images/icony_ikonate/save.svg": "175374af7616e0703c97abf712f4fe56",
"assets/packages/icony/assets/images/icony_ikonate/horn.svg": "ad69f93048ace384c97a5187c69756b9",
"assets/packages/icony/assets/images/icony_ikonate/previous.svg": "781eb9e44fb0d36709cc9ff6979842e8",
"assets/packages/icony/assets/images/icony_ikonate/switch-on.svg": "9e44df55c879a873c86a015c86e3cbc3",
"assets/packages/icony/assets/images/icony_ikonate/paperclip.svg": "7021bebd17517d89fdacdab4ed048eba",
"assets/packages/icony/assets/images/icony_ikonate/direction-right.svg": "292ceb8afb905adc9e05ea5a854e9b52",
"assets/packages/icony/assets/images/icony_ikonate/back.svg": "18490143ec121193d73a0efa5723628a",
"assets/packages/icony/assets/images/icony_ikonate/book-opened.svg": "68ba5dfc2f678197dadcf49857f87d1a",
"assets/packages/icony/assets/images/icony_ikonate/sticker.svg": "a7b64fb9810af19c8760d2026a71fd49",
"assets/packages/icony/assets/images/icony_ikonate/zoom-out.svg": "a589099f4dab82b9c9a05540e1585eea",
"assets/packages/icony/assets/images/icony_ikonate/box.svg": "3be9f5911d372e406a605bb7b240b3cf",
"assets/packages/icony/assets/images/icony_ikonate/battery-low.svg": "8025b155eaea44261f6a223e6ca47db8",
"assets/packages/icony/assets/images/icony_ikonate/mask.svg": "e081382e1b998ee50065c2db8e954ce2",
"assets/packages/icony/assets/images/icony_ikonate/directions-right.svg": "e60bccf8e78b318764fe6933af0288cd",
"assets/packages/icony/assets/images/icony_ikonate/person-add.svg": "c59b1d75fba4371d2c45dc12cfc971ac",
"assets/packages/icony/assets/images/icony_ikonate/play.svg": "bc71ea1029a8723c4995af54d51a1a6a",
"assets/packages/icony/assets/images/icony_ikonate/chat.svg": "3d70db67e7809764ef90919efc308dbd",
"assets/packages/icony/assets/images/icony_ikonate/camera-rear.svg": "93f3e6b3d7c38ef5753763a917eafeeb",
"assets/packages/icony/assets/images/icony_ikonate/dolar.svg": "d741942d6c1c30942171bba34f1539e9",
"assets/packages/icony/assets/images/icony_ikonate/sad-face.svg": "aa7ac062418f053cca9582b70aaf5291",
"assets/packages/icony/assets/images/icony_ikonate/send.svg": "dd80fe15ab7f19ddc18882d2928ed03d",
"assets/packages/icony/assets/images/icony_ikonate/lock-alt.svg": "63c8982544b0588a266b68baafb1c961",
"assets/packages/icony/assets/images/icony_ikonate/explore.svg": "b37fbf0c1230631d4a841fefb96288e1",
"assets/packages/icony/assets/images/icony_ikonate/camera.svg": "74539dd5e09498541733db08acb7b7f8",
"assets/packages/icony/assets/images/icony_ikonate/add-to-list.svg": "67efd85ab944fa3f8a0673ff7e49bbb4",
"assets/packages/icony/assets/images/icony_ikonate/redo.svg": "4c42df5aa141ad72842623e2ae580969",
"assets/packages/icony/assets/images/icony_ikonate/mute.svg": "1d73b6faaaa6999934966c4f32458a1a",
"assets/packages/icony/assets/images/icony_ikonate/ok-circle.svg": "114cb65840142d17eaf401dc090f67a4",
"assets/packages/icony/assets/images/icony_ikonate/radio-button-selected.svg": "4c333a470583af0ac4036b782c62a66e",
"assets/packages/icony/assets/images/icony_ikonate/sounds.svg": "eeefb83194311344ae1d494c1abc450a",
"assets/packages/icony/assets/images/icony_ikonate/feather.svg": "9cafc1e177a71d58e69ebeb039c3d580",
"assets/packages/icony/assets/images/icony_ikonate/star.svg": "2a2a58f814749dfb455e92279ea6e5d2",
"assets/packages/icony/assets/images/icony_ikonate/extension.svg": "4d7e1ab64408a5248cb9f30f932f3d21",
"assets/packages/icony/assets/images/icony_ikonate/sun.svg": "ccdbe06c09fafc22efc888da895ebdef",
"assets/packages/icony/assets/images/icony_ikonate/danger.svg": "e2c487340b322928357cc650894348a6",
"assets/packages/icony/assets/images/icony_ikonate/pizza.svg": "93bd7fec784e0e363a2879fdebeff9ff",
"assets/packages/icony/assets/images/icony_ikonate/edit.svg": "7d09fb4089b03a931b6ce88b8aa07c8b",
"assets/packages/icony/assets/images/icony_ikonate/next.svg": "e3c0dcac12d79035fb304945cab6cb6c",
"assets/packages/icony/assets/images/icony_ikonate/anchor.svg": "6af911571225f5f2cee6aeee77c0fa3f",
"assets/packages/icony/assets/images/icony_ikonate/checkbox.svg": "3dc9492d368878c74064185a5f0604b6",
"assets/packages/icony/assets/images/icony_ikonate/back-left.svg": "f967b970df3b23549428a461fba1eb26",
"assets/packages/icony/assets/images/icony_ikonate/chevrons-up.svg": "90100957a1c95e80ad62ff7d2d6fba9e",
"assets/packages/icony/assets/images/icony_ikonate/wheelchair.svg": "eeb016794cebe5a1a7d13fb0741fbe3e",
"assets/packages/icony/assets/images/icony_ikonate/turn-left.svg": "d68e1ed803f462177e658391b55ec96c",
"assets/packages/icony/assets/images/icony_ikonate/bug.svg": "c7409d78760ff3e967c742a65e9fa3bb",
"assets/packages/icony/assets/images/icony_ikonate/grid-small.svg": "50ccf73ae6ce2f4fba3756210a92dcdd",
"assets/packages/icony/assets/images/icony_ikonate/sun-cloud.svg": "fec21fe7bbc236fbe82e61a0e26bc593",
"assets/packages/icony/assets/images/icony_ikonate/controls.svg": "a03ba515ed2c055aa23739055b383093",
"assets/packages/icony/assets/images/icony_ikonate/back-alt.svg": "7a25b08c4d2b3324384b804f5e211332",
"assets/packages/icony/assets/images/icony_ikonate/crossing.svg": "98475f1abaf53d849c0950d2d5c06f5b",
"assets/packages/icony/assets/images/icony_ikonate/credit-card.svg": "689c70e5dd9e39dce6636307c4352581",
"assets/packages/icony/assets/images/icony_ikonate/arrow-right-bottom.svg": "19cfbe4d3b5d2ce285d74d889c23bc2b",
"assets/packages/icony/assets/images/icony_ikonate/share-android.svg": "c7f17cd1093afc860027d2fd9a124d11",
"assets/packages/icony/assets/images/icony_ikonate/language.svg": "8d70fc23d22f948d811b8ad1ad688f10",
"assets/packages/icony/assets/images/icony_ikonate/qr.svg": "6ce7156d02aedeb7225142a919e81ec7",
"assets/packages/icony/assets/images/icony_ikonate/basketball.svg": "cffcd8c85da4e62d21eb2f1422c21e38",
"assets/packages/icony/assets/images/icony_ikonate/exit.svg": "8dd1554370b75d49ee6e6801b2f40f5e",
"assets/packages/icony/assets/images/icony_ikonate/diamond.svg": "514cae7006a1d040381937adaa438a40",
"assets/packages/icony/assets/images/icony_ikonate/delete.svg": "68ab7d79bdcb4ceffd23804aaff9ed13",
"assets/packages/icony/assets/images/icony_ikonate/octagon.svg": "a664645ec2af2a06661c5ff2368fee6f",
"assets/packages/icony/assets/images/icony_ikonate/retweet.svg": "c4ca2fdffc2f2009adf75c3625c238c0",
"assets/packages/icony/assets/images/icony_ikonate/phone.svg": "3ff0e99f1371ae4810b49e9745f36e48",
"assets/packages/icony/assets/images/icony_ikonate/eye.svg": "935a5b389d453ad68d6dbb3c196b5431",
"assets/packages/icony/assets/images/icony_ikonate/new.svg": "d90c4813df2301a14917efe673a90862",
"assets/packages/icony/assets/images/icony_ikonate/location.svg": "15adf9367171d679fdd72e207960c575",
"assets/packages/icony/assets/images/icony_ikonate/flower.svg": "71525efc1fa5c6fd1c53434b433855d3",
"assets/packages/icony/assets/images/icony_ikonate/controls-alt.svg": "d33ee6b5434eb3a8c91819fee0580655",
"assets/packages/icony/assets/images/icony_ikonate/bin.svg": "e4b102b12a682fe064a7bb132033e646",
"assets/packages/icony/assets/images/icony_ikonate/line-chart.svg": "e54866e1dd1bb6b8cc68f31250f41cbb",
"assets/packages/icony/assets/images/icony_ikonate/car.svg": "5172c62977b145529b01a6ca36f470f1",
"assets/packages/icony/assets/images/icony_ikonate/colours.svg": "88d90a197114df370a85de26c9280ecb",
"assets/packages/icony/assets/images/icony_ikonate/share.svg": "856f18db65c60ae4679cfe3110bdf228",
"assets/packages/icony/assets/images/icony_ikonate/arrow-up.svg": "a3eb70a0742fed7aff5adcf86eb0969d",
"assets/packages/icony/assets/images/icony_ikonate/folder-add.svg": "de1f4737b50934cbb8c3682a64346b72",
"assets/packages/icony/assets/images/icony_ikonate/remove.svg": "4aace010344f1e25413787d8001d5083",
"assets/packages/icony/assets/images/icony_ikonate/undo.svg": "f78f32ada62436a917827e59bfa134ac",
"assets/packages/icony/assets/images/icony_ikonate/video.svg": "a889be15aa5f6466b436498c68821a6d",
"assets/packages/icony/assets/images/icony_ikonate/stack.svg": "84d7873b90a4c4d5128cfaa15b52df1b",
"assets/packages/icony/assets/images/icony_ikonate/activity.svg": "9219c4e79f6d2ae4f13ee18b039190ed",
"assets/packages/icony/assets/images/icony_ikonate/filter.svg": "860fcb9fa6f11fcfc8e2fe6f9403b810",
"assets/packages/icony/assets/images/icony_ikonate/chat-remove.svg": "ded9f0907595ff2c9eb53fb49387eeef",
"assets/packages/icony/assets/images/icony_ikonate/chevrons-left.svg": "06045aa4aa49ca19a8937e6b302f4a85",
"assets/packages/icony/assets/images/icony_ikonate/pan.svg": "f0414b79d67c0de46b652ec7a06fae82",
"assets/packages/icony/assets/images/icony_ikonate/calendar.svg": "46cf2ad748f21ed4b302754e568ca114",
"assets/packages/icony/assets/images/icony_ikonate/arrow-left.svg": "17edecfe73bcd7e3bb89611c2e45cd8c",
"assets/packages/icony/assets/images/icony_ikonate/align-center.svg": "c3da368c88c6b3a111840ff2dcdbed28",
"assets/packages/icony/assets/images/icony_ikonate/laptop.svg": "51d98330b3110492bc9f6485d1a4fb29",
"assets/packages/icony/assets/images/icony_ikonate/sign-language.svg": "f466cc17d6a4923100d0edb072314de8",
"assets/packages/icony/assets/images/icony_ikonate/battery-alt.svg": "fb694970ce5e275e13fda7198ca6d7a2",
"assets/packages/icony/assets/images/icony_ikonate/cut.svg": "b5826cba9e5fcedcade4c27d835c337f",
"assets/packages/icony/assets/images/icony_ikonate/cloud.svg": "7d73a6414dcc555ca3b6bfc361f8738c",
"assets/packages/icony/assets/images/icony_ikonate/hdr.svg": "134d46c387db61a86a05a59dfa9dad90",
"assets/packages/icony/assets/images/icony_ikonate/shuffle.svg": "b6897a4dafe06af0e598019de8d78e2f",
"assets/packages/icony/assets/images/icony_ikonate/window.svg": "7dc6d4e8a91c7eb8906f6fface829964",
"assets/packages/icony/assets/images/icony_ikonate/error.svg": "6737027e7f1a02b50f52f1e4473f903e",
"assets/packages/icony/assets/images/icony_ikonate/cup.svg": "8d0a314ef1c379f864998f4adf861d10",
"assets/packages/icony/assets/images/icony_ikonate/justify.svg": "fb328bbcc22bd0cf8e3e8ab8c64d90d7",
"assets/packages/icony/assets/images/icony_ikonate/suitcase.svg": "974380524a4a62cf43f8048622a08d60",
"assets/packages/icony/assets/images/icony_ikonate/upload.svg": "8673aa2e1d32fb7d39a0c6de67e99bb3",
"assets/packages/icony/assets/images/icony_ikonate/trending-down.svg": "0b103aa74fe24e84c2183fb98da50cb2",
"assets/packages/icony/assets/images/icony_ikonate/minimise.svg": "f76c3962e5054b168e100668f3391543",
"assets/packages/icony/assets/images/icony_ikonate/pause.svg": "021f3249ad559d59bea245449f85b548",
"assets/packages/icony/assets/images/icony_ikonate/arrow-down-circle.svg": "f9d50bcc6b85b5930cb698f8a5f05dfc",
"assets/packages/icony/assets/images/icony_ikonate/forward.svg": "180a35022aac48dcfe2284728b48a595",
"assets/packages/icony/assets/images/icony_ikonate/bookmark.svg": "af7f47af48d5b2d4d4641e532166d77d",
"assets/packages/icony/assets/images/icony_ikonate/help.svg": "c5bb1537bc8337f956d78df503a4f2c0",
"assets/packages/icony/assets/images/icony_ikonate/rocket.svg": "46bcb66ad8e2e37cbe1958eef4518566",
"assets/packages/icony/assets/images/icony_ikonate/transport.svg": "1a2608b6e3126cdf6596ff1da6657015",
"assets/packages/icony/assets/images/icony_ikonate/layout-left.svg": "5a12fd06b8cb9c56c8b8849acd17f3a8",
"assets/packages/icony/assets/images/icony_ikonate/iphone.svg": "7632bcde61a8d46a27afc0fccbc23fd2",
"assets/packages/icony/assets/images/icony_ikonate/ear.svg": "44f16cbfc97a14e98a3b005d09981cce",
"assets/packages/icony/assets/images/icony_ikonate/car-alt.svg": "de5c983bd57277e630c8cdbab3511db7",
"assets/packages/icony/assets/images/icony_ikonate/component.svg": "e104844a8fc470d2b51cad40b257d084",
"assets/packages/icony/assets/images/icony_ikonate/lock-open.svg": "04d935aacc11fc5d554bed095917a581",
"assets/packages/icony/assets/images/icony_ikonate/drop.svg": "e393089810d3c3fe943222b24a2fc6c3",
"assets/packages/icony/assets/images/icony_ikonate/brightness.svg": "541609fb599ac210334b158dfb71886f",
"assets/packages/icony/assets/images/icony_ikonate/poll.svg": "bcabf58c2dbf4eb7729add5571e4bf23",
"assets/packages/icony/assets/images/icony_ikonate/arrow-right-top.svg": "2f1c988a661d53b1c8755d6f4feed2ed",
"assets/packages/icony/assets/images/icony_ikonate/sort-down.svg": "98ec3a6fd1ee1afdfc15c488192f2d63",
"assets/packages/icony/assets/images/icony_ikonate/stats.svg": "1135f5959d9ddc2f520d449a3c6c5685",
"assets/packages/icony/assets/images/icony_ikonate/mouse.svg": "d53a367b1a972db92a7451fe695fa224",
"assets/packages/icony/assets/images/icony_ikonate/inbox-alt.svg": "e2926034b53577ef45d1e06829701d28",
"assets/packages/icony/assets/images/icony_ikonate/history.svg": "152b6b589c863df51947525afeab0a5f",
"assets/packages/icony/assets/images/icony_ikonate/cards.svg": "f60bfbf7e558d2a4e4a851472c8decf9",
"assets/packages/icony/assets/images/icony_ikonate/folder.svg": "1779d55d74c923fe4e2afbc6095494ca",
"assets/packages/icony/assets/images/icony_ikonate/alarm.svg": "9a2e42b806ed5aec2d7ee4e50fb751b6",
"assets/packages/icony/assets/images/icony_ikonate/controls-vertical-alt.svg": "dad8ca66b9dddc60a6d4bbfbde5497bb",
"assets/packages/icony/assets/images/icony_ikonate/basket.svg": "7f5599e48031b8672a12a2ae01e0af85",
"assets/packages/icony/assets/images/icony_ikonate/arrow-left-top.svg": "b9fd2b55bad0fdf595433bfa9973595e",
"assets/packages/icony/assets/images/icony_ikonate/timer.svg": "986e69c451a94ba95c1e5b9c5cd3df8c",
"assets/packages/icony/assets/images/icony_ikonate/walking.svg": "7104e61d3f9441f72bc2c059acf491aa",
"assets/packages/icony/assets/images/icony_ikonate/minus.svg": "08ebdcc7036cd934ed216d01442dafb2",
"assets/packages/icony/assets/images/icony_ikonate/volume-quiet.svg": "ef2b17afcaf825a67b46e2a94f0a6bf6",
"assets/packages/icony/assets/images/icony_ikonate/chevron-left.svg": "c9f57730dd646494dcd5ceaad86b1c19",
"assets/packages/icony/assets/images/icony_ikonate/film.svg": "f04f9528a841a135490b425837514dd0",
"assets/packages/icony/assets/images/icony_ikonate/print.svg": "069167c96ed1f011a22dc58cad7cdee3",
"assets/packages/icony/assets/images/icony_ikonate/moon.svg": "c41893dcd3a66d6da5034b785884ad69",
"assets/packages/icony/assets/images/icony_ikonate/accessibility.svg": "bc061aaa22e1b8fe277179b6f590a248",
"assets/packages/icony/assets/images/icony_ikonate/chat-add.svg": "c35920b5805016c1405847403b64eedf",
"assets/packages/icony/assets/images/icony_ikonate/notebook.svg": "8d006fdb7f4a6745b349138ec0f5ec23",
"assets/packages/icony/assets/images/icony_ikonate/sort-up.svg": "3df368198831e9bae5d814be922e7536",
"assets/packages/icony/assets/images/icony_ikonate/align-left.svg": "2da64709ef07f1cc1e21635445118f31",
"assets/packages/icony/assets/images/icony_ikonate/trending-up.svg": "5505c8b2637197610bdcb28ea34b6ea7",
"assets/packages/icony/assets/images/icony_ikonate/placeholder.svg": "e4eb172b6c2216d8d1d50af1a70bf416",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"assets/AssetManifest.bin": "deff66bbad6afb3cd9c2acc57755f043",
"assets/fonts/MaterialIcons-Regular.otf": "9ea02d43bae317d9e48506c7ad6a0bac",
"assets/assets/images/parchment.png": "008b246fb188bf25e5c99de8d37407e1",
"assets/assets/images/vintage-grunge-paper-background.jpg": "c8fdd63c1090e458c0e0fb786d5f893b",
"assets/assets/images/2210_w032_n002_607b_p15_607.jpg": "a69736325e2cbbb96864887bd7ff1972",
"assets/assets/images/v37-wit-40-job129.jpg": "17ec753798bbd6fe2082c9b5c095d889",
"assets/assets/images/FelisChaus_ParchmentBackground.jpg": "0633c097990ba42cfedf6d84d04382f1",
"canvaskit/skwasm.js": "95f16c6690f955a45b2317496983dbe9",
"canvaskit/skwasm.wasm": "d1fde2560be92c0b07ad9cf9acb10d05",
"canvaskit/chromium/canvaskit.js": "ffb2bb6484d5689d91f393b60664d530",
"canvaskit/chromium/canvaskit.wasm": "393ec8fb05d94036734f8104fa550a67",
"canvaskit/canvaskit.js": "5caccb235fad20e9b72ea6da5a0094e6",
"canvaskit/canvaskit.wasm": "d9f69e0f428f695dc3d66b3a83a4aa8e",
"canvaskit/skwasm.worker.js": "51253d3321b11ddb8d73fa8aa87d3b15"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
