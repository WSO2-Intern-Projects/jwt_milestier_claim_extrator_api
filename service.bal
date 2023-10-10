import ballerina/http;
import ballerina/jwt;
import ballerina/io;

const string DEFAULT_USER = "default";

service / on new http:Listener(9090) {

    resource function get GetLoyaltyTier/[string num](http:Headers headers) returns int|string|http:BadRequest|json|error {
        string|error jwtAssertion = headers.getHeader("x-jwt-assertion");
        io:println(jwtAssertion);
        if (jwtAssertion is error) {
            http:BadRequest badRequest = {
                body: {
                    "error": "Bad Request",
                    "error_description": "Error while getting the JWT token"
                }
            };
            return badRequest;
        }

        [jwt:Header, jwt:Payload] [_, payload] = check jwt:decode(jwtAssertion);
        json username = payload.toJson();
        string loyaltyTier = (check username.milestier).toString(); //is string ? <string>payload.sub : DEFAULT_USER;

        int FrequentFlyerMiles = 0;
        int actualMiles = check int:fromString(num);
        if (loyaltyTier.equalsIgnoreCaseAscii("Platinum")) {

            FrequentFlyerMiles = actualMiles * 3;
            return FrequentFlyerMiles;

        } else if (loyaltyTier.equalsIgnoreCaseAscii("Gold")) {
            FrequentFlyerMiles = actualMiles * 2;
            return FrequentFlyerMiles;

        } else if (loyaltyTier.equalsIgnoreCaseAscii("Silver")) {
            FrequentFlyerMiles = actualMiles * 1;
            return FrequentFlyerMiles;

        }

        // return FrequentFlyerMiles;
        return jwtAssertion;
    }
}

