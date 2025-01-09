import ballerina/http;
import ballerina/io;
import ballerina/oauth2;
import ballerina/time;
import ballerinax/hubspot.crm.engagement.notes as engagementNotes;

// Variables required for authentication
configurable string clientId = ?;
configurable string clientSecret = ?;
configurable string refreshToken = ?;

// ID of the test company created for testing
configurable string companyId = ?;

engagementNotes:OAuth2RefreshTokenGrantConfig auth = {
    clientId,
    clientSecret,
    refreshToken,
    credentialBearer: oauth2:POST_BODY_BEARER // This line should be added when you are going to create auth object.
};

final engagementNotes:Client hubSpotNotes = check new ({auth});

public function main() returns error? {
    // Creating a note
    io:println("Creating a note...");

    engagementNotes:SimplePublicObjectInputForCreate createPayload =
    {
        associations: [
            {
                types: [
                    {
                        associationCategory: "HUBSPOT_DEFINED",
                        associationTypeId: 190
                    }
                ],
                to: {
                    id: companyId
                }
            }
        ],
        properties: {
            "hs_timestamp": time:utcToString(time:utcNow()),
            "hs_note_body": "Spoke with decision maker Carla. Attached the proposal and draft of contract."
        }
    };

    engagementNotes:SimplePublicObject createResponse = check hubSpotNotes->/.post(createPayload);

    string noteId = createResponse.id;
    io:println("Note created with id: ", noteId);

    // Updating the body of the created note
    io:println("Updating the note...");

    engagementNotes:SimplePublicObjectInput payload =
    {
        properties: {
            "hs_note_body": "Spoke with decision maker Carla."
        }
    };

    engagementNotes:SimplePublicObject updateResponse = check hubSpotNotes->/[noteId].patch(payload);
    io:println("Note updated at: ", updateResponse.updatedAt);
    io:println("Updated content: ", updateResponse.properties);

    // Getting the newly updated note
    io:println("Reading the note...");

    engagementNotes:SimplePublicObjectWithAssociations readResponse = check hubSpotNotes->/[noteId]();
    io:println("Note content: ", readResponse.properties);

    // Search for the new note by content
    io:println("Searching for the note containing \"Carla\"...");

    engagementNotes:PublicObjectSearchRequest searchPayload =
    {
        filterGroups: [
            {
                filters: [
                    {
                        propertyName: "hs_note_body",
                        value: "Called to Carla.",
                        operator: "EQ"
                    }
                ]
            }
        ]
    };

    engagementNotes:CollectionResponseWithTotalSimplePublicObjectForwardPaging searchResponse = check hubSpotNotes->/search.post(searchPayload);
    io:println("Results received: ", searchResponse.results);

    // Delete note
    io:println("Deleting note...");

    http:Response _ = check hubSpotNotes->/[noteId].delete();

    // Getting all available notes
    io:println("All notes: ");

    engagementNotes:CollectionResponseSimplePublicObjectWithAssociationsForwardPaging readAllResponse = check hubSpotNotes->/();
    io:println(readAllResponse);
}
