import asyncio
from app.services import event_bus


def test_ticket_is_one_time():
    async def run():
        ticket=await event_bus.issue_ticket(123,"control",ttl_seconds=30)
        assert await event_bus.consume_ticket(ticket,123)=="control"
        assert await event_bus.consume_ticket(ticket,123) is None
    asyncio.run(run())
