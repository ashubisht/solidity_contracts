"use strict";

const chai = require("chai");
const chaiAsPromised = require("chai-as-promised");

const BN = web3.utils.BN;
const chaiBN = require("chai-bn")(BN);

require("dotenv").config({ path: "../.env" });

chai.use(chaiBN);
chai.use(chaiAsPromised);

module.exports = chai;
