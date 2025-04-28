const path = require('path')
const swaggerJSDoc = require('swagger-jsdoc');

const swaggerOptions = {
    swaggerDefinition: {
        openapi: '3.0.4',
        info: {
            title: 'My API',
            version: '1.0.0',
            description: 'API documentation using Swagger',
        },
        servers: [
            {
                url: 'http://localhost:5000/api',
                description: 'Main (production) server',
            },
        ]
    },
    apis: [
        path.join(__dirname, '../routes/*.js'),       // Top-level routes
        path.join(__dirname, '../routes/**/*.js')     // All subdirectories
    ],

};

const swaggerSpec = swaggerJSDoc(swaggerOptions);

module.exports = swaggerSpec;