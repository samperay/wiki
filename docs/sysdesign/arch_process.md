## Functional system requirements

The requirements are usually defined by the system analysts

Functional requirements outline the specific functions, features, and capabilities that a system or software must provide to meet the needs of users and achieve its intended purpose. These requirements describe the interactions between the system and its users, as well as the system's behavior under various conditions.

Examples of functional requirements:

"Users must be able to create an account and log in."
"The system shall allow users to add items to their shopping cart."
"The software must generate monthly sales reports."
"The website should display a list of recommended articles based on user preferences."

## Non-Functional system requirememts

Non-functional requirements define the qualities, characteristics, and constraints that govern how the system performs rather than what it does. These requirements focus on aspects such as performance, security, reliability, usability, and other attributes that contribute to the overall quality and user experience of the system.

**Performance**: "The system must be able to handle a minimum of 1000 concurrent users without significant degradation in response time."
**Security**: "User passwords must be securely hashed and stored in the database."
**Reliability**: "The system should have an uptime of at least 99.9%."
**Usability**: "The user interface must be intuitive and accessible to users with disabilities."
**Scalability**: "The system architecture should support easy scaling to accommodate increased user load."
**Maintainability**: "Code must be well-documented and adhere to coding standards."
**Compatibility**: "The software must be compatible with major web browsers, including Chrome, Firefox, and Safari."

## Component mapping

Effective communication with **stakeholders, including users, clients, developers, and testers**, is crucial throughout this process. Regularly review and refine the mapped components to ensure that all requirements are accurately captured and prioritized. This mapping process serves as a foundation for **design, development, testing, and evaluation** activities during the system's lifecycle.

## Select technology stack 

- After mapping the components, you would be required to wisely select the technology stack, that includes the frontend, backend, data stores etc

## Design architecture

The architectural design process aims to define how different software modules or components will interact, how data will flow, and how the system will achieve its intended functionality while adhering to quality attributes. Here's an overview of the steps involved in designing software architecture:

1. **Requirements Analysis and Understanding:**
   - Gather and analyze the functional and non-functional requirements of the software system.
   - Understand the user needs, business goals, and technical constraints that the architecture must address.

2. **System Decomposition and Module Identification:**
   - Break down the software system into smaller, manageable modules or components.
   - Identify the major functional areas and define the responsibilities of each module.

3. **Architectural Styles and Patterns Selection:**
   - Choose appropriate architectural styles (e.g., client-server, microservices, layered, event-driven) that best suit the system's requirements.
   - Apply well-established architectural patterns (e.g., MVC, MVVM, RESTful API) to address common design challenges.

4. **Component Interaction and Communication:**
   - Define how different modules will communicate and interact with each other.
   - Determine communication protocols, data formats, and interfaces between components.

5. **Data Management and Storage:**
   - Design the data storage and management mechanisms, including databases, data models, and data access layers.
   - Address data consistency, integrity, and security requirements.

6. **User Interface Design:**
   - Create a user interface design that aligns with user needs and provides an intuitive user experience.
   - Determine the layout, navigation, and presentation of information.

7. **Security and Authentication:**
   - Plan for security measures, including user authentication, authorization, data encryption, and protection against common vulnerabilities.

8. **Scalability and Performance Considerations:**
   - Address scalability requirements by designing for horizontal or vertical scalability, load balancing, and caching strategies.
   - Optimize the system's performance through efficient algorithms and proper resource management.

9. **Error Handling and Resilience:**
   - Design error handling mechanisms to gracefully handle exceptions and failures.
   - Implement strategies for fault tolerance, redundancy, and system recovery.

10. **Integration with External Services:**
    - Define how the software system will integrate with external APIs, third-party services, and other systems.

11. **Documentation and Communication:**
    - Document the architectural decisions, design rationale, and key design patterns used.
    - Communicate the architecture to the development team, stakeholders, and collaborators.

12. **Review and Validation:**
    - Conduct architecture reviews and design discussions to validate the proposed architecture against requirements.
    - Address any feedback and make necessary adjustments.

13. **Implementation and Development:**
    - Translate the architectural design into code by developing individual modules and components.
    - Ensure that the implementation adheres to the defined architecture and design principles.

14. **Continuous Improvement:**
    - Regularly review and refine the architecture as the project progresses and new insights are gained.
    - Consider feedback from users, performance metrics, and evolving requirements.

## Write architecture document. 

- Use visial or document representation so that all the users including CTO, CFO, developers, testers would be able to check the document to understand the system. 
- Any changes in the architectute or the document has to be updated with changes.

## Support team 

- Once the system is in production, we would be required to maintain system for reliability and so on, hence we would be required to support the team for any issues or help. 