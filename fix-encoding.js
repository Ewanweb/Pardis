const fs = require("fs");
const path = require("path");

const filePath =
  "FrontEnd/pardis-client/src/components/profile/ProfileEditModal.jsx";

try {
  let content = fs.readFileSync(filePath, "utf8");

  // Replace corrupted Persian text with proper Persian text
  content = content.replace(/U\+OU\. U\+U\.UO\?\?OO\?U\^OU\+O_/g, "نام کامل");
  content = content.replace(/OUOU\.UOU,/g, "ایمیل");
  content = content.replace(/O' U\.OO\?U\? U\.U\^O"OUOU,/g, "شماره تماس");
  content = content.replace(/OrU,OO\?U\? U_O\?U\^U\?OUOU,/g, "اطلاعات فعلی");
  content = content.replace(/O\?O1O\?UOU\? U\+O'O_U\?/g, "تعریف نشده");
  content = content.replace(
    /U\^UOO\?OUOO' U_O\?U\^U\?OUOU,/g,
    "ویرایش پروفایل"
  );
  content = content.replace(
    /O\?O\?U\^UOO\? U_O\?U\^U\?OUOU,/g,
    "تصویر پروفایل"
  );

  // Fix the specific error-causing line
  content = content.replace(
    /`U\+OU\. U\+U\.UO\?\?OO\?U\^OU\+O_ U\+U\.UO\?\?OO\?U\^OU\+O_ O"UOO' OO\? 200 UcOO\?OUcO\?O\? O"OO'O_`/g,
    "`نام کامل نباید بیشتر از 200 کاراکتر باشد`"
  );

  fs.writeFileSync(filePath, content, "utf8");
  console.log("File encoding fixed successfully!");
} catch (error) {
  console.error("Error fixing file:", error);
}
