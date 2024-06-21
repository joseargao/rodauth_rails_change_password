# README

This was a minimal rails project that demonstrated how the changed_at column did not get automatically updated when
change-password was used. However, it turns out that this was only happening because the original version of this test used Timecop for time manipulation while rodauth updates the changed_at column to CURRENT_TIMESTAMP which is not affected by Timecop.

It has been updated and the tests now pass without the need for manually updating the changed_at column.
