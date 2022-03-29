const sqlite3 = require('sqlite3').verbose();

const spacesFileName = 'spaces'
const spacesDBFilePath = './' + spacesFileName +  '.db'

const reservationsFileName = 'reservations'
const reservationsDBFilePath = './' + reservationsFileName +  '.db'

const usersFileName = 'users'
const favoriteTableName = 'favorites'
const usersDBFilePath = './' + usersFileName +  '.db'

//Atm running three separate databases for security and performance reasons; database(table1): spaces(spaces), reservations(reservations), users(users, favorites)

//The space is deemed free if: 1) It is available in spaces (between start and endtime)
//2) There is no reservation time associated with the space on the said time in the reservations DB.

//TIETOKANNAN TO-DO:
//-Lisää postinumero
//-Tee kuville oma tietokanta

//Lisää lähde-URL
function initializeSpacesDB() {
    const db = new sqlite3.Database(spacesDBFilePath);
        db.run("CREATE TABLE " + spacesFileName + " (" +
            "nameRedux TEXT NOT NULL," +
            " addressRedux TEXT NOT NULL," +
            " name TEXT NOT NULL," +
            " address TEXT NOT NULL," +
            " city TEXT NOT NULL," +
            " type TEXT NOT NULL," +
            " image TEXT DEFAULT NULL," +
            " price INTEGER NOT NULL," +
            " startTime TEXT NOT NULL, " +
            " endTime TEXT NOT NULL, " +
            " info TEXT DEFAULT 'Vuokraa tila Roomien kautta!'," +
            " useInfo TEXT DEFAULT 'Lisätiedot saatavissa vuokratessa!'," +
            " CHECK (length(addressRedux) < 26 AND length(name) < 26 AND length(nameRedux) < 26 AND price >= 0 AND price < 999999 AND length(address) < 26 AND length(city) < 16 AND " +
            "(type = 'saunatila' OR type = 'juhlatila' OR type = 'työskentelytila' " +
            "OR type = 'liikuntatila' OR type = 'mökki') AND (image = NULL OR image LIKE '%.jpg' OR image LIKE '%.png' OR image LIKE '%.jpeg')" +
            "AND length(image) < 100 AND startTime LIKE '20__-__-__ __:__' AND " +
            "startTime >= '2021-01-01 00:00' AND startTime <= '2099-12-31 23:59' AND endTime LIKE '20__-__-__ __:__' AND " +
            "endTime >= '2021-01-01 00:00' AND endTime <= '2099-12-31 23:59' AND startTime < endTime AND length(info) < 501 AND length(useInfo) < 301)" + "," +
            " PRIMARY KEY(addressRedux, nameRedux));", function(err) {
        if (err) {
            return console.log(err.message);
        }
    });
    db.close();
}

function initializeReservationsDB() {
    //nameRedux, addressRedux, FK to spaces DB.
    //username, FK to users DB.
    //PK resNumber, generated on spot, 16 chars.
    const rdb = new sqlite3.Database(reservationsDBFilePath);

    rdb.run("CREATE TABLE " + reservationsFileName + " (" +
        "resNumber TEXT NOT NULL PRIMARY KEY," +
        " nameRedux TEXT NOT NULL," +
        " addressRedux TEXT NOT NULL," +
        " username TEXT NOT NULL," +
        " city TEXT NOT NULL," +
        " type TEXT NOT NULL," +
        " resStartTime TEXT NOT NULL, " +
        " resEndTime TEXT NOT NULL, " +
        " info TEXT DEFAULT 'Lisäinfo asiakkaalta'," +
        " CHECK (length(resNumber) = 16 AND length(addressRedux) < 26 AND length(nameRedux) < 26 AND length(city) < 16 AND " +
        "(type = 'saunatila' OR type = 'juhlatila' OR type = 'työskentelytila' " +
        "OR type = 'liikuntatila' OR type = 'mökki') AND resStartTime LIKE '20__-__-__ __:__' AND " +
        "resStartTime >= '2021-01-01 00:00' AND resStartTime <= '2099-12-31 23:59' AND resEndTime LIKE '20__-__-__ __:__' AND " +
        "resEndTime >= '2021-01-01 00:00' AND resEndTime <= '2099-12-31 23:59' AND resStartTime < resEndTime AND length(info) < 501))", function(err) {
        if (err) {
            return console.log(err.message);
        }
    });
    rdb.close();
}

function initializeUsersDB() {
    const udb = new sqlite3.Database(usersDBFilePath);

    udb.run("CREATE TABLE " + usersFileName + " (" +
        "username TEXT NOT NULL PRIMARY KEY," +
        " passwordHash TEXT NOT NULL," +
        " email TEXT NOT NULL," +
        " phone TEXT NOT NULL," +
        " name TEXT NOT NULL," +
        " address TEXT NOT NULL," +
        " city TEXT NOT NULL," +
        " country TEXT NOT NULL," +
        " active INTEGER NOT NULL," +
        " info TEXT DEFAULT 'Lisätietoja käyttäjästä'," +
        " CHECK (length(email) < 26 AND email LIKE '%@%' AND length(username) < 26 AND length(passwordHash) = 64 AND (active = 0 OR active = 1) AND length(name) < 26 AND length(address) < 31 " +
        " AND length(city) < 21 AND length(country) < 21 AND length(info) < 121 AND length(phone) < 15))", function(err) {

        if (err) {
            return console.log(err.message);
        }
    });
    udb.close();
}
function addUsertoDB(username, passwordHash, email, phone, name, address, city, country, active, info) {
    const udb = new sqlite3.Database(usersDBFilePath)

    udb.run(
        "INSERT INTO "+ usersFileName +" (username, passwordHash, email, phone, name, address, city, country, active, info) " +
        "VALUES (?,?,?,?,?,?,?,?,?,?)", username, passwordHash, email, name, phone, address, city, country, active, info, function(err) {
            if (err) {
                return console.log(err.message);
            }
        }
    );
    udb.close();
}

function userFetch(value, attribute) {
    const udb = new sqlite3.Database(usersDBFilePath)
    udb.each(
        "SELECT " + "*" +  " FROM " + usersFileName + " WHERE " + attribute + "=?", value, (err, row) => {
            if (err) {
                return console.log(err.message);
            }
            console.log(row);
        }
    );
    udb.close();
}

function initializeFavoriteTable() {

    const udb = new sqlite3.Database(usersDBFilePath);

    udb.run("CREATE TABLE " + favoriteTableName + " (" +
        "username TEXT NOT NULL," +
        " nameRedux TEXT NOT NULL," +
        " addressRedux TEXT NOT NULL," +
         " CHECK ((length(addressRedux) < 26 AND length(nameRedux) < 26)), PRIMARY KEY (username, nameRedux, addressRedux)" +
        " );", function(err) {
        if (err) {
            return console.log(err.message);
        }
    });
    udb.close();
}

function addFavorite(username, nameRedux, addressRedux) {
    const udb = new sqlite3.Database(usersDBFilePath)

    udb.run(
        "INSERT INTO "+ favoriteTableName +" (username, nameRedux, addressRedux) " +
        "VALUES (?,?,?)", username, nameRedux, addressRedux, function(err) {
            if (err) {
                return console.log(err.message);
            }
        }
    );
    udb.close();
}

function fetchFavorite(value, attribute) {
    const udb = new sqlite3.Database(usersDBFilePath)
    udb.each(
        "SELECT " + "*" +  " FROM " + favoriteTableName + " WHERE " + attribute + "=?", value, (err, row) => {
            if (err) {
                return console.log(err.message);
            }
            console.log(row);
        }
    );
    udb.close();
}


function addReservationtoDB(resNumber, nameRedux, addressRedux, username, city, type, resStartTime, resEndTime, info) {

    const rdb = new sqlite3.Database(reservationsDBFilePath)

    rdb.run(
        "INSERT INTO "+ reservationsFileName +" (resNumber, nameRedux, addressRedux, username, city, type, resStartTime, resEndTime, info) " +
        "VALUES (?,?,?,?,?,?,?,?,?)",resNumber, nameRedux, addressRedux, username, city, type, resStartTime, resEndTime, info, function(err) {
            if (err) {
                return console.log(err.message);
            }
        }
    );
    rdb.close();
}

function reservationFetch(value, attribute) {
    const rdb = new sqlite3.Database(reservationsDBFilePath)
    rdb.each(
        "SELECT " + "*" +  " FROM " + reservationsFileName + " WHERE " + attribute + "=?", value, (err, row) => {
            if (err) {
                return console.log(err.message);
            }
            console.log(row);
        }
    );
    rdb.close();
}

//TO-DO: create backup function

//PK-requirement checks for similar address and name written wrongly.

function addSpacetoDB(name, address, city, type, image, price, startTime, endTime, info, useInfo) {

    const addressRedux = address.replace(/\s/g, '').toLowerCase()
    const nameRedux = name.replace(/\s/g, '').toLowerCase()

    const db = new sqlite3.Database(spacesDBFilePath)

    db.run(
        "INSERT INTO "+ spacesFileName +" (nameRedux, addressRedux, name, address, city, type, image, price, startTime, endTime, info, useInfo) " +
        "VALUES (?,?,?,?,?,?,?,?,?,?,?,?)",nameRedux, addressRedux, name, address, city, type, image, price, startTime,
            endTime, info, useInfo, function(err) {
            if (err) {
                return console.log(err.message);
            }
        }
    );
    db.close();
}

function spaceFetch(value, attribute) {
    const db = new sqlite3.Database(spacesDBFilePath)
    db.each(
        "SELECT " + "*" +  " FROM " + spacesFileName + " WHERE " + attribute + "=?", value, (err, row) => {
            if (err) {
                return console.log(err.message);
            }
            console.log(row);
        }
    );
    db.close();
}

function fetchByName(value) {
    const db = new sqlite3.Database(spacesDBFilePath)
    const valueRedux = value.replace(/\s/g, '').toLowerCase()
    db.each(
        "SELECT " + "*" +  " FROM "+ spacesFileName +" WHERE " + "name" + "=?", valueRedux, (err, row) => {
            if (err) {
                return console.log(err.message);
            }
            console.log(row);
        }
    );
    db.close();
}

function fetchByAddress(value) {
    const db = new sqlite3.Database(spacesDBFilePath)
    const valueRedux = value.replace(/\s/g, '').toLowerCase()
    db.each(
        "SELECT " + "*" +  " FROM "+ spacesFileName +" WHERE " + "address" + "=?", valueRedux, (err, row) => {
            if (err) {
                return console.log(err.message);
            }
            console.log(row);
        }
    );
    db.close();
}

function fetchByType(value) {
    const db = new sqlite3.Database(spacesDBFilePath)
    const valueRedux = value.replace(/\s/g, '').toLowerCase()
    db.each(
        "SELECT " + "*" +  " FROM "+ spacesFileName +" WHERE " + "type" + "=?", valueRedux, (err, row) => {
            if (err) {
                return console.log(err.message);
            }
            console.log(row);
        }
    );
    db.close();
}

function fetchByCity(value) {
    const db = new sqlite3.Database(spacesDBFilePath)
    const valueRedux = value.replace(/\s/g, '').toLowerCase()
    db.each(
        "SELECT " + "*" +  " FROM "+ spacesFileName +" WHERE " + "city" + "=?", valueRedux, (err, row) => {
            if (err) {
                return console.log(err.message);
            }
            console.log(row);
        }
    );
    db.close();
}

function fetchByPriceLowerThan(value) {
    const db = new sqlite3.Database(spacesDBFilePath)
    db.each(
        "SELECT " + "*" +  " FROM "+ spacesFileName +" WHERE " + "price" + "<=", value, (err, row) => {
            if (err) {
                return console.log(err.message);
            }
            console.log(row);
        }
    );
    db.close();
}

function fetchByPriceHigherThan(value) {
    const db = new sqlite3.Database(spacesDBFilePath)
    db.each(
        "SELECT " + "*" +  " FROM "+ spacesFileName +" WHERE " + "price" + ">=", value, (err, row) => {
            if (err) {
                return console.log(err.message);
            }
            console.log(row);
        }
    );
    db.close();
}

//Stuff used for testing, ignore

//initializeSpacesDB()
//initializeReservationsDB()

//addReservationtoDB("1234567890123456", "testi", "kirkkokatu5a", "makeM", "Espoo", "mökki", "2021-06-01 12:00", "2021-07-01 12:00", "Joo laitas pari kaljaa jääkaappiin -Make" )
//reservationFetch("1234567890123456", "resNumber")
//initializeUsersDB()
//userFetch("makeM", "username")
/*addSpacetoDB('Servin Mökki', 'Kirkkokatu 5 A', 'Espoo', 'mökki', 'www.testi.fi/mörskä.jpg', 40,
   '2021-06-06 12:00', '2021-07-06 13:00', 'Ihan ok.', 'Mörskän avaimet hukassa, riko ikkuna.')*/
//initializeFavoriteTable()
//addFavorite("makeM", "metsästysmaja", "kirkkokatu5a")
//fetchFavorite("makeM", "username")
//initializeUsersDB()
//addUsertoDB("testi", "9148a95045ec48290b5e68cc04d24ee278fae554b7c4b7b5620f866786a797f4", "testi@testi.fi", "0451360928", "Testi Testinen", "testikuja 1", "Espoo", "Finland", 0, "Testikäyttäjä")