const std = @import("std");
const testing = std.testing;
const c = @import("c.zig");

test "resize image" {
    const image_in = c.sod_img_load_from_file(
        "test_data/flower.jpg",
        c.SOD_IMG_COLOR,
    );
    defer c.sod_free_image(image_in);
    try testing.expect(image_in.data != 0);
    try testing.expect(image_in.w > 4);
    try testing.expect(image_in.h > 4);

    const image_out = c.sod_resize_image(
        image_in,
        @intCast(@divTrunc(image_in.w, 2)),
        @intCast(@divTrunc(image_in.h, 2)),
    );
    defer c.sod_free_image(image_out);

    const output_path = "out_resize.png";
    _ = c.sod_img_save_as_png(image_out, output_path);
    try std.fs.cwd().deleteFile(output_path);
}
