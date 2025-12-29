# Implementation Plan: Simplified Slider System

## Overview

Simplify the slider system by removing complex fields and features while maintaining core functionality. The implementation focuses on backend entity simplification, frontend component updates, proper image upload handling, and data migration from the existing complex structure.

## Tasks

- [x] 1. Create simplified domain entities

  - Update HeroSlide entity to include only core fields: Title, Description, ImageUrl, ActionLabel, ActionLink, Order, IsActive
  - Update SuccessStory entity with same simplified structure
  - Remove complex properties: Stats, Badge, Secondary Actions, Expiration, Permanent flags
  - _Requirements: 1.1, 1.2, 2.1, 2.2_

- [x] 1.1 Write property test for entity structure simplification

  - **Property 1: Entity Structure Simplification**
  - **Validates: Requirements 1.1, 1.2, 2.1, 2.2, 6.1**

- [x] 2. Create simplified DTOs

  - Create new CreateHeroSlideDto and UpdateHeroSlideDto with essential fields only
  - Create new CreateSuccessStoryDto and UpdateSuccessStoryDto with essential fields only
  - Add proper validation attributes for required fields
  - Support both ImageFile upload and ImageUrl input
  - _Requirements: 1.5, 2.5, 3.1, 3.4_

- [x] 2.1 Write property test for required field validation

  - **Property 2: Required Field Validation**
  - **Validates: Requirements 1.5, 2.5, 3.4**

- [x] 2.2 Write property test for entity structure consistency

  - **Property 9: Entity Structure Consistency**
  - **Validates: Requirements 2.4**

- [x] 3. Implement image upload service

  - Create image upload handler with file validation (type, size)
  - Implement secure file storage with unique filename generation
  - Generate accessible URLs for uploaded images
  - Add proper error handling for invalid files
  - _Requirements: 3.1, 3.2, 3.5_

- [x] 3.1 Write property test for image upload processing

  - **Property 3: Image Upload Processing**
  - **Validates: Requirements 3.1, 3.2**

- [x] 3.2 Write property test for file validation

  - **Property 4: File Validation**
  - **Validates: Requirements 3.5**

- [x] 4. Update application handlers

  - Simplify CreateHeroSlideHandler to use new simplified DTO
  - Simplify UpdateHeroSlideHandler with partial update support
  - Simplify CreateSuccessStoryHandler to use new simplified DTO
  - Simplify UpdateSuccessStoryHandler with partial update support
  - Remove complex logic for stats, expiration, badges
  - _Requirements: 4.4, 3.3, 6.2_

- [x] 4.1 Write property test for partial update handling

  - **Property 6: Partial Update Handling**
  - **Validates: Requirements 4.4, 3.3**

- [x] 5. Update API controllers

  - Simplify HeroSlidesController to use new DTOs
  - Simplify SuccessStoriesController to use new DTOs
  - Ensure multipart/form-data support for image uploads
  - Update response formats to include only essential fields
  - _Requirements: 5.1, 5.2, 5.3, 5.4, 5.5_

- [x] 5.1 Write property test for API response structure

  - **Property 7: API Response Structure**
  - **Validates: Requirements 5.4, 5.5**

- [x] 6. Update query handlers

  - Simplify GetHeroSlidesHandler to return only essential fields
  - Simplify GetSuccessStoriesHandler to return only essential fields
  - Remove complex filtering logic for expiration and stats
  - Update response DTOs to match simplified structure
  - _Requirements: 5.4, 6.2_

- [x] 7. Create data migration scripts

  - Create migration to preserve existing Title, Description, ImageUrl
  - Map legacy ButtonText to ActionLabel and LinkUrl to ActionLink
  - Set default values for new required fields (Order, IsActive)
  - Create rollback script for migration reversal
  - _Requirements: 8.1, 8.2, 8.3, 8.4, 8.5_

- [x] 7.1 Write property test for migration data preservation

  - **Property 10: Migration Data Preservation**
  - **Validates: Requirements 8.1, 8.2, 8.3, 8.4**

- [x] 8. Checkpoint - Test backend changes

  - Ensure all tests pass, ask the user if questions arise.

- [x] 9. Update frontend API service

  - Simplify SliderApiService to use new simplified data structure
  - Update data transformation functions for new field mapping
  - Remove complex logic for stats, badges, secondary actions
  - Ensure proper multipart/form-data handling for image uploads
  - _Requirements: 4.1, 4.3, 5.3_

- [x] 9.1 Write property test for frontend-backend data mapping

  - **Property 5: Frontend-Backend Data Mapping**
  - **Validates: Requirements 4.1, 4.3**

- [x] 10. Simplify HeroSlider component

  - Update component to display only Title, Description, Image, and one Action button
  - Remove complex UI elements for stats, badges, secondary actions
  - Handle missing optional fields gracefully
  - Maintain responsive design with simplified layout
  - _Requirements: 7.1, 7.4_

- [x] 10.1 Write property test for component display consistency

  - **Property 8: Component Display Consistency**
  - **Validates: Requirements 7.1, 7.2, 7.4**
  - **Status: PARTIALLY PASSING** - 2/3 tests pass, 1 test failing due to edge case handling

- [x] 11. Simplify StorySlider component

  - Update component to display only Title, Description, Image, and one Action button
  - Remove complex UI elements for stats, badges, types, duration
  - Handle missing optional fields gracefully
  - Ensure consistent structure with HeroSlider
  - _Requirements: 7.2, 7.4_

- [x] 12. Update slider management interface

  - Simplify admin forms to include only essential fields
  - Remove form fields for stats, badges, secondary actions, expiration
  - Update form validation to match new simplified structure
  - Ensure image upload functionality works properly
  - _Requirements: 7.3_

- [-] 13. Remove legacy code

  - Remove unused properties from entities after migration
  - Remove complex expiration logic and temporary slide features
  - Remove legacy compatibility properties
  - Clean up unused DTOs and handlers
  - Update database schema to remove unused columns
  - _Requirements: 6.1, 6.2, 6.3, 6.4, 6.5_

- [ ] 13.1 Write property test for legacy code elimination

  - **Property 11: Legacy Code Elimination**
  - **Validates: Requirements 6.2, 6.3**

- [-] 14. Final checkpoint - Integration testing

  - Test complete create/update/delete flows for both HeroSlides and SuccessStories
  - Verify frontend-backend synchronization works properly
  - Test image upload functionality end-to-end
  - Verify migration preserves existing data correctly
  - Ensure all legacy code has been removed

## Notes

- All tasks are required for comprehensive implementation
- Each task references specific requirements for traceability
- Checkpoints ensure incremental validation
- Property tests validate universal correctness properties
- Focus on simplification while maintaining core functionality
- Migration tasks ensure existing data is preserved during transition
