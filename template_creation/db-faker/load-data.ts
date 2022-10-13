import { DataTypes, Sequelize } from "sequelize";
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
    // --- Get fake data ---
    const userObjs: any[] = JSON.parse(fs.readFileSync("./fake-data.json", "utf-8"))

    // --- Add fake data to database ---
    const sql = new Sequelize("postgres://postgres:postgres@localhost:5432/postgres");
    await sql.authenticate();
    console.log("Authenticated with DB");

    // Initialize table
    const User = sql.define("user", {
        name: {
            type: DataTypes.STRING,
        },
        
        date_of_birth: {
            type: DataTypes.STRING,
        },

        employment_start_date: {
            type: DataTypes.STRING,
        },

        email: {
            type: DataTypes.STRING,
        },

        phone_number: {
            type: DataTypes.STRING
        },

        username: {
            type: DataTypes.STRING,
        },

        password: {
            type: DataTypes.STRING
        }
    }, {
        timestamps: false
    })

    await User.sync();
    console.log("User table created");

    // Create users
    await User.bulkCreate(userObjs)
    console.log("Added users!")

    // Save data and close DB connection
    await sql.close()
    console.log("Fake data successfully added!");
})()
