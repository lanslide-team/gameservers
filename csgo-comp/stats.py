import asyncio
import os
import time
from opengsq.protocols import Source
from rcon.source import Client


class Query:
    SOURCE_RESPONSE: list[str] = ['Name', 'Map', 'Players', 'MaxPlayers', 'GamePort']
    DEFAULT_SLEEP: int = 5

    @classmethod
    def __process_info(cls, response: dict, response_keys: list[str]) -> dict:
        result = {}
        for tag in response_keys:
            result[tag] = response[tag]
        return result

    @classmethod
    def __process_command(cls, client, command):
        lines = client.run(command).split('\n')
        output = ""

        for line in lines:
            if not line.startswith('L '):
                output += line.strip()

        return output

    @classmethod
    async def process_game(cls, protocol: callable, response_keys: list[str], address: str, query_port: int, rcon_password: str, timeout: float = 5.0) -> dict:
        while True:
            try:
                response = protocol(address=address, query_port=query_port, timeout=timeout)
                response = await response.get_info()
                processed_response = cls.__process_info(response=response, response_keys=response_keys)

                score = ls_status = None
                with Client(address, int(query_port), passwd=rcon_password) as client:
                    score = cls.__process_command(client, 'score')
                    ls_status = cls.__process_command(client, 'ls_status')

                processed_response['score'] = score
                processed_response['ls_status'] = ls_status
            except asyncio.exceptions.TimeoutError:
                processed_response = {'Error': 'Timeout'}

            f = open('stats.json', 'w')
            f.write(str(processed_response))
            f.close()

            time.sleep(cls.DEFAULT_SLEEP)


if __name__ == '__main__':
    ip = input()
    asyncio.run(Query.process_game(protocol=Source, response_keys=Query.SOURCE_RESPONSE, address=ip, query_port=os.environ['PORT'], rcon_password=os.environ['RCON_PASSWORD'], timeout=1))

