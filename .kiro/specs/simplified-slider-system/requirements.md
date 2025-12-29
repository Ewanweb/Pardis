# Requirements Document

## Introduction

Create a simplified slider system that synchronizes frontend and backend with essential fields only. Remove unnecessary complexity from the current slider implementation while maintaining image upload functionality and ensuring proper API integration between React frontend and .NET backend.

## Glossary

- **HeroSlider**: Main slider component displayed on homepage
- **SuccessStory**: Secondary slider for success stories
- **SliderAPI**: Backend API endpoints for slider management
- **ImageUpload**: File upload functionality for slider images
- **SliderSync**: Synchronization between frontend and backend data

## Requirements

### Requirement 1: Simplified HeroSlider Entity

**User Story:** As a developer, I want a simplified HeroSlider entity with only essential fields, so that the system is maintainable and easy to use.

#### Acceptance Criteria

1. THE HeroSlider SHALL have only these core fields: Title (required), Description (optional), ImageUrl (required), ActionLabel (optional), ActionLink (optional), Order (required), IsActive (required)
2. THE HeroSlider SHALL remove all complex fields like Stats, Badge, Secondary Actions, Expiration, and Permanent flags
3. THE HeroSlider SHALL support image file upload through ImageFile property
4. THE HeroSlider SHALL maintain backward compatibility during migration
5. THE HeroSlider SHALL have proper validation for required fields

### Requirement 2: Simplified SuccessStory Entity

**User Story:** As a developer, I want a simplified SuccessStory entity with only essential fields, so that success stories are easy to manage.

#### Acceptance Criteria

1. THE SuccessStory SHALL have only these core fields: Title (required), Description (optional), ImageUrl (required), ActionLabel (optional), ActionLink (optional), Order (required), IsActive (required)
2. THE SuccessStory SHALL remove complex fields like Stats, Badge, Type, StudentName, CourseName, Duration, and Expiration
3. THE SuccessStory SHALL support image file upload through ImageFile property
4. THE SuccessStory SHALL maintain consistent structure with HeroSlider
5. THE SuccessStory SHALL have proper validation for required fields

### Requirement 3: Image Upload Functionality

**User Story:** As an admin, I want to upload images for sliders, so that I can easily add visual content without managing URLs manually.

#### Acceptance Criteria

1. WHEN creating a slider, THE system SHALL accept image file uploads
2. WHEN an image file is uploaded, THE system SHALL store it securely and generate a URL
3. WHEN updating a slider, THE system SHALL allow replacing the existing image
4. WHEN no image file is provided, THE system SHALL require an ImageUrl
5. THE system SHALL validate image file types and sizes

### Requirement 4: Frontend-Backend Synchronization

**User Story:** As a developer, I want perfect synchronization between frontend and backend, so that slider operations work reliably.

#### Acceptance Criteria

1. WHEN frontend sends slider data, THE backend SHALL receive all fields correctly mapped
2. WHEN backend returns slider data, THE frontend SHALL display all information properly
3. WHEN creating sliders, THE API SHALL use consistent field names between frontend and backend
4. WHEN updating sliders, THE API SHALL handle partial updates correctly
5. THE system SHALL provide clear error messages for validation failures

### Requirement 5: Clean API Endpoints

**User Story:** As a developer, I want clean and simple API endpoints, so that slider management is straightforward.

#### Acceptance Criteria

1. THE HeroSlides API SHALL provide GET, POST, PUT, DELETE operations with simplified DTOs
2. THE SuccessStories API SHALL provide GET, POST, PUT, DELETE operations with simplified DTOs
3. WHEN calling APIs, THE system SHALL use multipart/form-data for image uploads
4. WHEN returning data, THE APIs SHALL include only essential fields
5. THE APIs SHALL provide consistent response formats

### Requirement 6: Remove Legacy Code

**User Story:** As a developer, I want to remove unused legacy code, so that the codebase is clean and maintainable.

#### Acceptance Criteria

1. THE system SHALL remove unused properties from entities (Stats, Badge, Secondary Actions, etc.)
2. THE system SHALL remove complex expiration logic and temporary slide features
3. THE system SHALL remove legacy compatibility properties after migration
4. THE system SHALL clean up unused DTOs and handlers
5. THE system SHALL update database schema to remove unused columns

### Requirement 7: Frontend Component Simplification

**User Story:** As a developer, I want simplified frontend components, so that slider display and management is straightforward.

#### Acceptance Criteria

1. THE HeroSlider component SHALL display only Title, Description, Image, and one Action button
2. THE StorySlider component SHALL display only Title, Description, Image, and one Action button
3. THE slider management interface SHALL provide forms with only essential fields
4. WHEN displaying sliders, THE components SHALL handle missing optional fields gracefully
5. THE components SHALL maintain responsive design with simplified layout

### Requirement 8: Data Migration

**User Story:** As a developer, I want to migrate existing slider data to the simplified structure, so that current content is preserved.

#### Acceptance Criteria

1. WHEN migrating HeroSlides, THE system SHALL preserve Title, Description, ImageUrl, and primary action
2. WHEN migrating SuccessStories, THE system SHALL preserve Title, Description, ImageUrl, and action
3. THE migration SHALL map legacy ButtonText to ActionLabel and LinkUrl to ActionLink
4. THE migration SHALL set default values for new required fields
5. THE migration SHALL provide rollback capability in case of issues
