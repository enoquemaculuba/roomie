// ignore_for_file: prefer_const_constructors

import 'package:roomie/util/services.dart';
import 'package:roomie/widgets/util.dart';

PlaceCard kimmonsauna() {
  return PlaceCard(
    name: 'Kimmonsauna',
    type: 'Saunatila',
    adequacy: '98',
    city: 'Espoo',
    image: 'sauna1.jpg',
    price: 40,
    address: 'Kimmon Saunakatu 10 A 5',
    time: '18-00',
    services: [cleaningService(15), organiser(45), drinkService(75)],
    reservations: const [],
    info:
        'Saunatila sopii varsinki teekkarijuhliin! Tila on vasta remontoitu 2020 keväällä...',
    usageInfo: 'Ovikoodi 1267. Avaimia säilytetään kukkaruukussa...',
  );
}

PlaceCard onninsauna() {
  return PlaceCard(
      name: 'Onninsauna',
      type: 'Saunatila',
      adequacy: '90',
      city: 'Kirkkonummi',
      image: 'sauna2.jpg',
      price: 50,
      address: 'Onnin Saunakuja 2 A 66',
      time: '18-00',
      reservations: const [],
      services: [cleaningService(20), drinkService(75)]);
}

PlaceCard oskunsauna() {
  return const PlaceCard(
    name: 'Oskunsauna',
    type: 'Saunatila',
    adequacy: '93',
    city: 'Espoo',
    image: 'sauna3.jpg',
    price: 40,
    address: 'Uuno kailaan katu 3 D 44',
    time: '18-00',
    reservations: [],
  );
}

PlaceCard makenmorska() {
  return PlaceCard(
    name: 'Maken Mörskä',
    type: 'Mökki',
    adequacy: '11',
    city: 'Lohja',
    image: 'makenmorska.jpg',
    price: 10,
    address: 'Metsätie 5',
    time: '16-04',
    reservations: const [],
    services: [drinkService(10)],
    info:
        'Paljon elämää nähnyt, mutta sitäkin tunnelmallisempi rentotumispaikka Nuuksion kansallispuistossa.',
    usageInfo:
        'Vuokraus omalla vastuulla, Make hoitaa juomapuolen sovittaessa.',
  );
}

PlaceCard hulppeahuvila() {
  return PlaceCard(
    name: 'Villa Costoso',
    type: 'Mökki',
    adequacy: '92',
    city: 'Porvoo',
    image: 'hulppeahuvila.jpg',
    price: 600,
    address: 'Rantapolku 1',
    time: '00-00',
    reservations: const [],
    services: [cleaningService(200), organiser(150), drinkService(120)],
    info:
        'Ihastuttava huvila meren rannalla, tästä pytingistä ei luksusta puutu! Saavu paikalle vaikka omalla paatillasi.',
    usageInfo: 'Saat avainkorttisi henkilökunnaltamme paikalle saapuessasi.',
  );
}

PlaceCard levinmokki() {
  return PlaceCard(
    name: 'Villa Arctica',
    type: 'Mökki',
    adequacy: '84',
    city: 'Levi',
    image: 'levinmokki.jpg',
    price: 350,
    address: 'Tunturitie 8',
    time: '14-12',
    reservations: const [],
    services: [cleaningService(100)],
    info: '20 henkilön kolmikerroksinen huippumökki Levin lomakylässä.',
    usageInfo: 'Avaimet saat vastaanotostamme osoitteesta Kittiläntie 6.',
  );
}

PlaceCard espoonlahti() {
  return PlaceCard(
    name: 'Espoonlahden Liikuntahalli',
    type: 'Liikuntatila',
    adequacy: '90',
    city: 'Espoo',
    image: 'espoonlahti.jpg',
    price: 60,
    address: 'Rehtorintie 11',
    time: '18-22',
    reservations: const [],
    info:
        'Kokonaispinta-ala 880 m² (40m x 22m). Halli voidaan jakaa kolmeen yhtä suureen osaan katosta laskeutuvilla väliseinillä.',
    usageInfo:
        'Sisäänpääsy koodilla, jonka lähetämme 15min ennen varauksen alkua.',
  );
}

PlaceCard friisila() {
  return PlaceCard(
    name: 'Friisilän koulun Liikuntasali',
    type: 'Liikuntatila',
    adequacy: '79',
    city: 'Espoo',
    image: 'friisilä.jpg',
    price: 40,
    address: 'Holmanniitynkuja 10',
    time: '17-23',
    reservations: const [],
    info:
        'Lattiassa rajat esimerkiksi salibandyä, koripalloa ja futsalia varten. Mahdollisuus jakaa sali kahteen osaan.',
    usageInfo:
        'Sisäänpääsy koodilla, jonka lähetämme 15min ennen varauksen alkua.',
  );
}

PlaceCard viikki() {
  return PlaceCard(
    name: 'UniSport Viikki Iso Sali',
    type: 'Liikuntatila',
    adequacy: '80',
    city: 'Helsinki',
    image: 'viikki.jpg',
    price: 80,
    address: 'Kevätkatu 2',
    time: '18-21',
    reservations: const [],
    info:
        'Normaalikoulun iso sali on tilava sali esimerkiksi joukkuelajeille. Salissa järjestät monipuoliset liikuntatapahtumat, tyhy- tai virkistyspäivät tai vaikkapa joukkueillan.',
    usageInfo:
        'Sisäänpääsy joko UniSport-kortilla tai vaihtoehtoisesti sähköisellä koodilla.',
  );
}

PlaceCard viikkipieni() {
  return PlaceCard(
    name: 'UniSport Viikki Pieni Sali',
    type: 'Liikuntatila',
    adequacy: '42',
    city: 'Helsinki',
    image: 'viikkipieni.jpg',
    price: 80,
    address: 'Kevätkatu 2',
    time: '18-21',
    reservations: const [],
    info:
        'Pieni sali on sopiva sali esimerkiksi keho ja mieli -lajeille, kamppailulajeihin ja kehonpainoharjoitteluun. Tilassa järjestät mukavan tyhy- tai virkistyspäivän.',
    usageInfo:
        'Sisäänpääsy joko UniSport-kortilla tai vaihtoehtoisesti sähköisellä koodilla.',
  );
}

PlaceCard neukkari1() {
  return PlaceCard(
    name: 'Roba43 Neuvotteluhuone',
    type: 'Työtila',
    adequacy: '90',
    city: 'Helsinki',
    image: 'roba43.jpg',
    price: 21,
    address: 'Iso Roobertinkatu 43A',
    time: '13-16',
    reservations: const [],
    //services: [cleaningService(100)],
    info:
        '20 henkilön Neuvotteluhuone Isolla Roobertinkadulla. Tilassa videotykki, televisio ja fläppitauluja esitysten pitämiseen.',
    usageInfo:
        'Sisäänpääsy koodilla, jonka saat tekstiviestillä varauksesi alkaessa.',
  );
}

PlaceCard neukkari2() {
  return PlaceCard(
    name: 'Kampin Neuvotteluhuone',
    type: 'Työtila',
    adequacy: '99',
    city: 'Helsinki',
    image: 'neukkari2.jpg',
    price: 40,
    address: 'Yrjönkatu 8A 6',
    time: '13-16',
    reservations: const [],
    //services: [cleaningService(100)],
    info:
        'Kymmenen henkilön neuvottelutila tiiviisiin neuvotteluihin. Tilassa televisio, johon on kätevää yhdistää tietokone.',
    usageInfo:
        'Sisäänpääsy koodilla, jonka saat tekstiviestillä 15min ennen varauksesi alkua.',
  );
}

PlaceCard pikkuneukkari() {
  return PlaceCard(
    name: 'Töihin.com 2Hlö, Töölö',
    type: 'Työtila',
    adequacy: '94',
    city: 'Helsinki',
    image: 'pikkuneukkari.jpg',
    price: 20,
    address: 'Eino Leinon katu 7A 4',
    time: '08-16',
    reservations: const [],
    //services: [cleaningService(100)],
    info:
        'Kahden henkilön työtila Helsingin Töölössä. Tilassa kaksi tuolia ja pöytä.',
    usageInfo:
        'Sisäänpääsy koodilla, jonka saat tekstiviestillä 15min ennen varauksesi alkua.',
  );
}

PlaceCard juhla1() {
  return PlaceCard(
    name: 'Juhlatila M6',
    type: 'Juhlatila',
    adequacy: '96',
    city: 'Helsinki',
    image: 'juhla1.jpg',
    price: 550,
    address: 'Mannerheimintie 6A',
    time: '10-02',
    reservations: const [],
    services: [cleaningService(80), organiser(60), drinkService(120)],
    info:
        'Juhlatila M6 sijaitsee huikealla paikalla aivan Helsingin ydinkeskustassa Stockmannia ja Svenska Teaternia vastapäätä.',
    usageInfo:
        'Sisäänpääsy koodilla, jonka saat tekstiviestillä 15min ennen varauksesi alkua.',
  );
}

PlaceCard juhla2() {
  return PlaceCard(
    name: 'Espoon Talli',
    type: 'Juhlatila',
    adequacy: '87',
    city: 'Espoo',
    image: 'juhla2.jpg',
    price: 320,
    address: 'Finnoontie 3',
    time: '10-02',
    reservations: const [],
    services: [cleaningService(60), organiser(50), drinkService(70)],
    info:
        'Upea vanhaan talliin rakennettu tunnelmallinen juhlatila. Soveltuu erinomaisesti esimerkiksi hääjuhlien tai pikkujoulujen pitämiseen.',
    usageInfo: 'Avaamme tilan käyttöösi ennen varaustasi.',
  );
}

PlaceCard juhla3() {
  return PlaceCard(
    name: 'Kupittaan Paviljonki',
    type: 'Juhlatila',
    adequacy: '84',
    city: 'Turku',
    image: 'juhla3.jpg',
    price: 300,
    address: 'Mannertie 6',
    time: '12-00',
    reservations: const [],
    services: [cleaningService(65), drinkService(80)],
    info:
        'Ihastuttavan valoisa ja tunnelmallinen juhlatila Suomen Turussa vaikkapa häitä tai akateemisia pöytäjuhlia varten.',
    usageInfo: 'Toimitamme avaimet paikan päälle varauksesi alkaessa.',
  );
}

PlaceCard tyo1() {
  return PlaceCard(
    name: 'Yhden Hengen Työpiste',
    type: 'Työtila',
    adequacy: '92',
    city: 'Tampere',
    image: 'tyo1.jpg',
    price: 20,
    address: 'Tammertie 7a',
    time: '08-17',
    reservations: const [],
    //services: [cleaningService(65), drinkService(80)],
    info: 'Yhden hengen kätevä co-working -työpiste juna-aseman tuntumassa.',
    usageInfo:
        'Saat sisäänpääsykoodin tekstiviestitse 15min ennen varauksesi alkua.',
  );
}

PlaceCard tyo2() {
  return PlaceCard(
    name: 'Neljän hengen akustinen työpiste',
    type: 'Työtila',
    adequacy: '89',
    city: 'Vantaa',
    image: 'tyo2.jpg',
    price: 35,
    address: 'Teknologiatie 2',
    time: '08-18',
    reservations: const [],
    //services: [cleaningService(65), drinkService(80)],
    info: 'Neljän hengen akustinen työpiste SuperTechin toimitiloissa',
    usageInfo:
        'Pääovet auki arkisin klo 7.45-18.15. Aulapalvelumme ohjastavat sinut perille tarvittaessa.',
  );
}

PlaceCard hirsisauna() {
  return PlaceCard(
    name: 'Hirsisauna',
    type: 'Saunatila',
    adequacy: '86',
    city: 'Vantaa',
    image: 'hirsisauna.jpg',
    price: 15,
    address: 'Maalarinkuja 7',
    time: '16-23',
    reservations: const [],
    //services: [cleaningService(65), drinkService(80)],
    info:
        'Aito suomalainen hirsisauna. Sopii lähtökohtaisesti noin kuudelle henkilölle.',
    usageInfo:
        'Kerromme säännöllisesti vaihtuvan avaimen piilopaikan sähköpostitse ennen varauksesi alkua.',
  );
}

PlaceCard pyorosauna() {
  return PlaceCard(
    name: 'Pyörösauna',
    type: 'Saunatila',
    adequacy: '64',
    city: 'Sipoo',
    image: 'pyorosauna.jpg',
    price: 22,
    address: 'Kaaritie 12',
    time: '16-22',
    reservations: const [],
    //services: [cleaningService(65), drinkService(80)],
    info: 'Tyylikäs ja tilava sauna ainakin kahdeksalle hengelle.',
    usageInfo: 'Avain löytyy kotelosta, jonka numerokoodin saat sähköpostiisi.',
  );
}

PlaceCard pelican() {
  return PlaceCard(
    name: 'Pelican Self Storage 9m²',
    type: 'Varastotila',
    adequacy: '81',
    city: 'Helsinki',
    image: 'pelican.jpg',
    price: 5,
    address: 'Mäkelänkatu 62',
    time: '00-00',
    reservations: const [],
    //services: [cleaningService(65), drinkService(80)],
    info:
        'Helppokäyttöinen, turvallinen ja lämmin varastotila. Kyseinen varasto on kooltaan 9m², myös muita kokoja saatavilla!',
    usageInfo: 'Voit hakea avaimen toimistostamme maksettuasi varauksen.',
  );
}

PlaceCard vihtivarasto() {
  return PlaceCard(
    name: 'Varastotila C, 2,6m²',
    type: 'Varastotila',
    adequacy: '54',
    city: 'Vihti',
    image: 'vihtivarasto3.png',
    price: 2,
    address: 'Ratastie 5',
    time: '00-00',
    reservations: const [],
    //services: [cleaningService(65), drinkService(80)],
    info:
        'Kätevä ja lämmitetty varasto. Pinta-ala 2,6m², korkeus 2m. Tilassa ei saa säilyttää palavia aineita.',
    usageInfo: 'Ovessa paikka riippulukolle.',
  );
}

PlaceCard kamppivarasto() {
  return PlaceCard(
    name: 'Lönnrotinkadun Varasto',
    type: 'Varastotila',
    adequacy: '87',
    city: 'Helsinki',
    image: 'kamppivarasto.jpg',
    price: 10,
    address: 'Lönnrotinkatu 32',
    time: '00-00',
    reservations: const [],
    info:
        'Vuokrataan siisti varastotila 59 m² keskeltä Helsinkiä säilytystilaksi tai pienmuotoiseen askarteluun. Sijainti kellarikerroksessa, jonne kuljetaan henkilöhissillä tai rappusten kautta.',
    usageInfo: 'Sisäänpääsy itse määritettävällä ovikoodilla.',
  );
}

PlaceCard keravavarasto() {
  return PlaceCard(
    name: 'Minitalli.fi, Kerava',
    type: 'Varastotila',
    adequacy: '73',
    city: 'Kerava',
    image: 'kerava4.jpg',
    price: 12,
    address: '',
    time: '00-00',
    reservations: const [],
    info:
        'Kätevä ja uusi, hyvin varusteltu tila esimerkiksi auton talvisäilytykseen tai pieniin huoltotoimenpiteisiin. Tilassa wc, vesipiste ja öljynerotuskaivo. Pinta-ala 43m².',
    usageInfo: 'Avaimet saat toimistostamme arkisin klo 9-17.',
  );
}

List<PlaceCard> services() {
  return [
    kimmonsauna(),
    onninsauna(),
    oskunsauna(),
    makenmorska(),
    hulppeahuvila(),
    levinmokki(),
    espoonlahti(),
    friisila(),
    viikki(),
    viikkipieni(),
    neukkari1(),
    neukkari2(),
    pikkuneukkari(),
    juhla1(),
    juhla2(),
    juhla3(),
    tyo1(),
    tyo2(),
    hirsisauna(),
    pyorosauna(),
    pelican(),
    vihtivarasto(),
    kamppivarasto(),
    keravavarasto()
  ];
}

List<PlaceCard> recommended() {
  return [
    neukkari2(),
    kimmonsauna(),
    juhla1(),
    pikkuneukkari(),
    hulppeahuvila(),
    tyo1(),
    espoonlahti(),
    onninsauna(),
    tyo2(),
    juhla2(),
    hirsisauna(),
    juhla3(),
    viikki(),
    pelican(),
    kamppivarasto()
  ];
}

List<PlaceCard> favorites() {
  return [
    kimmonsauna(),
    tyo1(),
    levinmokki(),
    neukkari2(),
    friisila(),
    juhla1(),
    oskunsauna(),
    makenmorska()
  ];
}

List<PlaceCard> nearby() {
  return [
    kimmonsauna(),
    juhla2(),
    oskunsauna(),
    pikkuneukkari(),
    espoonlahti(),
    neukkari1(),
    friisila(),
    neukkari2(),
    juhla1(),
    tyo2(),
  ];
}

PlaceCard custom(
    String name,
    String type,
    String adequacy,
    String city,
    String image,
    int price,
    String address,
    String time,
    List<ReservationTuple> reservations,
    List<Service> services) {
  return PlaceCard(
      name: name,
      type: type,
      adequacy: adequacy,
      city: city,
      image: image,
      price: price,
      address: address,
      time: time,
      reservations: reservations,
      services: services);
}
