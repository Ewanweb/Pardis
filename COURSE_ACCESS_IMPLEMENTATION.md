# پیاده‌سازی شرط‌های دسترسی دوره بر اساس CourseType

## 🔍 نتایج Discovery

### نوع‌های واقعی CourseType:

```csharp
public enum CourseType
{
    Online = 1,     // آنلاین - دوره به صورت مجازی برگزار می‌شود
    InPerson = 2,   // حضوری - دوره در محل فیزیکی برگزار می‌شود
    Hybrid = 3      // ترکیبی - دوره هم آنلاین و هم حضوری دارد
}
```

### فیلدهای دسترسی موجود:

- **Location** (string): محل برگزاری یا آدرس - برای همه دوره‌ها
- **ExclusiveLiveLink** (string?): لینک اختصاصی ورود به کلاس - فقط در UserCourse
- **IsAccessBlocked** (bool): وضعیت مسدود بودن دسترسی

### دسته‌بندی نیازمندی‌ها:

- **Online**: نیاز به `ExclusiveLiveLink`
- **InPerson**: نیاز به `Location`
- **Hybrid**: نیاز به هر دو `Location` و `ExclusiveLiveLink`

## 📋 قوانین کسب‌وکار (Business Rules)

### 1. برای کاربران خریدار (isPurchased = true):

- **Online**: نمایش `ExclusiveLiveLink` (اگر موجود باشد)
- **InPerson**: نمایش `Location`
- **Hybrid**: نمایش هر دو (بر اساس موجود بودن)
- بررسی `IsAccessBlocked` - اگر true باشد، دسترسی نمایش داده نشود

### 2. برای کاربران غیرخریدار (isPurchased = false):

- هیچ اطلاعات دسترسی نمایش داده نشود
- فقط CTA خرید:
  - اگر `isInCart = false` → دکمه "افزودن به سبد"
  - اگر `isInCart = true` → دکمه "رفتن به سبد"

### 3. امنیت:

- فیلدهای دسترسی فقط از `/api/courses/my-enrollments` برگردند
- از `/api/courses` عمومی هیچ اطلاعات حساسی برنگردد

## 🔧 پیاده‌سازی فنی

### 1. DTO جدید برای دسترسی:

```typescript
interface CourseAccess {
  classLocation?: string; // برای InPerson و Hybrid
  liveUrl?: string; // برای Online و Hybrid
  isAccessBlocked: boolean; // وضعیت مسدود بودن
}

interface CourseDetailResponse {
  // ... سایر فیلدها
  courseType: "Online" | "InPerson" | "Hybrid";
  isPurchased: boolean;
  isInCart: boolean;
  access?: CourseAccess; // فقط برای خریداران
}
```

### 2. کامپوننت React:

```jsx
const CourseAccessSection = ({ course, isPurchased, isInCart }) => {
  if (!isPurchased) {
    return (
      <div className="purchase-cta">
        {isInCart ? (
          <Button onClick={() => navigate("/cart")}>رفتن به سبد خرید</Button>
        ) : (
          <Button onClick={handleAddToCart}>افزودن به سبد خرید</Button>
        )}
      </div>
    );
  }

  // برای خریداران
  const { courseType, access } = course;

  if (access?.isAccessBlocked) {
    return (
      <div className="access-blocked">
        <AlertTriangle className="text-red-500" />
        دسترسی شما به این دوره موقتاً مسدود شده است
      </div>
    );
  }

  return (
    <div className="course-access">
      {/* برای دوره‌های حضوری یا ترکیبی */}
      {(courseType === "InPerson" || courseType === "Hybrid") &&
        access?.classLocation && (
          <div className="location-info">
            <MapPin className="text-blue-500" />
            <span>محل برگزاری: {access.classLocation}</span>
          </div>
        )}

      {/* برای دوره‌های آنلاین یا ترکیبی */}
      {(courseType === "Online" || courseType === "Hybrid") &&
        access?.liveUrl && (
          <div className="live-access">
            <Button
              onClick={() => window.open(access.liveUrl, "_blank")}
              className="bg-green-600 hover:bg-green-700"
            >
              <Video className="ml-2" />
              ورود به کلاس آنلاین
            </Button>
          </div>
        )}
    </div>
  );
};
```

## 🧪 سناریوهای تست

### Online Course:

- **خریدار + لینک موجود**: نمایش دکمه "ورود به کلاس آنلاین"
- **خریدار + لینک ناموجود**: نمایش پیام "لینک دسترسی هنوز آماده نشده"
- **خریدار + دسترسی مسدود**: نمایش پیام مسدودی
- **غیرخریدار**: فقط CTA خرید

### InPerson Course:

- **خریدار + آدرس موجود**: نمایش آدرس کلاس
- **خریدار + دسترسی مسدود**: نمایش پیام مسدودی
- **غیرخریدار**: فقط CTA خرید

### Hybrid Course:

- **خریدار**: نمایش هر دو (آدرس + لینک) بر اساس موجود بودن
- **غیرخریدار**: فقط CTA خرید

## 🔒 نکات امنیتی

1. **Backend Enforcement**: فیلدهای دسترسی فقط برای خریداران برگردند
2. **Token-based Access**: لینک‌های آنلاین باید tokenized باشند
3. **Time-based Validation**: لینک‌ها فقط در زمان کلاس فعال باشند
4. **Rate Limiting**: محدودیت تعداد درخواست برای لینک‌های دسترسی

## 📱 UX Considerations

1. **Loading States**: نمایش loading هنگام بررسی وضعیت خرید
2. **Error Handling**: پیام‌های مناسب برای خطاهای مختلف
3. **Responsive Design**: نمایش مناسب در موبایل
4. **Accessibility**: پشتیبانی از screen readers
