# bot.py
import os, random, discord, math, datetime, time
import resources as res
from discord.ext import commands, tasks
from dotenv import load_dotenv

load_dotenv()
TOKEN = os.getenv('DISCORD_TOKEN')

bot = commands.Bot(command_prefix='$', help_command=None)

@bot.event
async def on_ready():
    print(f'{bot.user.name} has connected to Discord!')

@bot.command(name="cb")
async def cb(ctx, *args):
    name = ' '.join(args)

    remaining = res.addBuff("cb", name)
    await ctx.send(f"**Chief Builder** buff registered for **{name}**. Estimated time until buff activation: __{remaining} minute(s)__.")

@bot.command(name="gm")
async def gm(ctx, *args):
    name = ' '.join(args)

    remaining = res.addBuff("gm", name)
    await ctx.send(f"**Grand Maester** buff registered for **{name}**. Estimated time until buff activation: __{remaining} minute(s)__.")

@bot.command(name="test")
async def test(ctx):
    msg = "Asd"
    await ctx.send(msg)

bot.run(TOKEN)