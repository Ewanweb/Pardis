# Requirements Document

## Introduction

Fix the API integration issue in the SliderManager component where slide creation fails due to incorrect field mapping between frontend and backend API. The error "عنوان الزامی است" (Title is required) occurs because the frontend is not properly mapping form data to the expected API field names.

## Glossary

- **SliderManager**: React component for managing hero slides and success stories
- **HeroSlides_API**: Backend API endpoint for managing hero slides (/api/HeroSlides)
- **FormData_Mapping**: Process of converting frontend form data to API-expected format
- **Field_Validation**: Client-side validation before API submission

## Requirements

### Requirement 1: Fix API Field Mapping

**User Story:** As an admin, I want to create new hero slides successfully, so that I can manage website content without errors.

#### Acceptance Criteria

1. WHEN creating a new slide, THE SliderManager SHALL map frontend form fields to correct API field names
2. WHEN the Title field is provided, THE SliderManager SHALL send it as "Title" to the API
3. WHEN button text is provided, THE SliderManager SHALL send it as "ButtonText" and "PrimaryActionLabel" to the API
4. WHEN button link is provided, THE SliderManager SHALL send it as "ButtonLink" and "PrimaryActionLink" to the API
5. WHEN secondary action fields are provided, THE SliderManager SHALL send them as "SecondaryActionLabel" and "SecondaryActionLink"

### Requirement 2: Handle Image Upload and URL

**User Story:** As an admin, I want to provide either an image URL or upload an image file, so that I can add visual content to slides flexibly.

#### Acceptance Criteria

1. WHEN an image URL is provided, THE SliderManager SHALL send it as "ImageUrl" to the API
2. WHEN an image file is uploaded, THE SliderManager SHALL send it as "ImageFile" to the API
3. WHEN both image URL and file are provided, THE SliderManager SHALL prioritize the uploaded file
4. WHEN neither image URL nor file is provided, THE SliderManager SHALL show validation error

### Requirement 3: Map Slide Type and Expiration

**User Story:** As an admin, I want to set slide types (permanent/temporary), so that I can control slide visibility duration.

#### Acceptance Criteria

1. WHEN slideType is "permanent", THE SliderManager SHALL send "IsPermanent" as true
2. WHEN slideType is "temporary", THE SliderManager SHALL send "IsPermanent" as false and include "ExpiresAt"
3. WHEN expiresAt is provided, THE SliderManager SHALL format it as ISO date-time string
4. WHEN order is provided, THE SliderManager SHALL send it as "Order" integer

### Requirement 4: Handle Update Operations

**User Story:** As an admin, I want to update existing slides, so that I can modify content without recreating slides.

#### Acceptance Criteria

1. WHEN updating a slide, THE SliderManager SHALL include "IsActive" field in the request
2. WHEN updating a slide, THE SliderManager SHALL preserve existing image if no new image is provided
3. WHEN updating a slide, THE SliderManager SHALL use PUT method with slide ID in URL path
4. WHEN update is successful, THE SliderManager SHALL refresh the slides list

### Requirement 5: Validation and Error Handling

**User Story:** As an admin, I want clear validation messages, so that I can understand what information is required.

#### Acceptance Criteria

1. WHEN Title field is empty, THE SliderManager SHALL show validation error before API call
2. WHEN API returns validation errors, THE SliderManager SHALL display specific error messages
3. WHEN API call fails, THE SliderManager SHALL show user-friendly error message
4. WHEN validation passes, THE SliderManager SHALL enable the save button

### Requirement 6: Success Stories API Integration

**User Story:** As an admin, I want to manage success stories with the same reliability as hero slides, so that both content types work consistently.

#### Acceptance Criteria

1. WHEN creating success stories, THE SliderManager SHALL use correct API field mapping
2. WHEN success story has subtitle, THE SliderManager SHALL send it as "Subtitle"
3. WHEN success story has type, THE SliderManager SHALL send it as "Type"
4. WHEN success story operations complete, THE SliderManager SHALL show appropriate success/error messages
