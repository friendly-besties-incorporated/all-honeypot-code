import { DataTypes, Sequelize } from "sequelize";
import { faker } from "@faker-js/faker"
import fs from "fs"

/**
 * This script connects to the postgres database on the container and adds a
 * table with fake user information for honey. They honey consists of:
 * 
 * - Name
 * - Date of Birth
 * - Employment Start Date
 * - Email 
 * - Phone Number
 * - Username
 * - Password
 */

const FAKE_ENTRIES_MIN = 100
const FAKE_ENTRIES_MAX = 100

function getRndInteger(min: number, max: number) {
    return Math.floor(Math.random() * (max - min) ) + min;
}

(async () => {
    // --- Generate fake data ---
    const numberEntriesToAdd = getRndInteger(FAKE_ENTRIES_MIN, FAKE_ENTRIES_MAX);
    const userObjs: any[] = []

    for (var i = 0; i < numberEntriesToAdd; i++) {
        let firstName = faker.name.firstName()
        let middleName = faker.name.middleName()
        let lastName = faker.name.lastName();
        let fullName = `${firstName} ${middleName} ${lastName}`
        let userName = `${firstName[0].toLowerCase()}${middleName[0].toLowerCase()}${lastName.slice(0,5).toLowerCase()}`.replace("'", "")
        let email = `${userName}@faculty.umd.edu`

        userObjs.push({
            name: fullName,
            date_of_birth: faker.date.birthdate(),
            employment_start_date: faker.date.between("2010-01-01", "2022-09-01"),
            email: email,
            phone_number: faker.phone.number('###-###-####'),
            username: userName,
            password: faker.internet.password()
        })
    }
   
    fs.writeFileSync("./fake-data.json", JSON.stringify(userObjs))
})()
