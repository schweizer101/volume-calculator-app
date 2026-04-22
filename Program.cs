var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.UseDefaultFiles();
app.UseStaticFiles();

app.MapPost("/calculate", async (HttpContext context) =>
{
    var form = await context.Request.ReadFormAsync();

    double L = double.Parse(form["length"]);
    double W = double.Parse(form["width"]);
    double H = double.Parse(form["height"]);
    double r = double.Parse(form["radius"]);

    double rectangular = L * W * H;
    double semiCylinder = 0.5 * Math.PI * r * r * L;

    double total = rectangular + semiCylinder;

    await context.Response.WriteAsync($"Total Volume: {total:F2}");
});

app.Run();