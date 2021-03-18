def addBuff(buff, name):
    if buff == "cb":
        with open('cb.txt', 'r') as buffs:
            buffContent = buffs.readlines()

        if len(buffContent) == 0:
            with open('cb.txt', 'a') as buffs:
                buffs.write(f"{buff},{name}")
        else:
            with open('cb.txt', 'a') as buffs:
                buffs.write(f"\n{buff},{name}")

        return len(buffContent) + 1

    if buff == "gm":
        with open('gm.txt', 'r') as buffs:
            buffContent = buffs.readlines()

        if len(buffContent) == 0:
            with open('gm.txt', 'a') as buffs:
                buffs.write(f"{buff},{name}")
        else:
            with open('gm.txt', 'a') as buffs:
                buffs.write(f"\n{buff},{name}")

        return len(buffContent) + 1

    return -1