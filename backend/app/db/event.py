import datetime


class Event:
    def __init__(self, creator: str = 'You', place=None, event_type: str = 'Чих Пых',
                 time: datetime.date = datetime.date(2025, 1, 1)):
        self.creator = creator
        # self.admins = [] мб лист юзеров (user_id), я пока хз TODO()
        self.place = place
        self.type = event_type
        self.time = time
        self.subscribers = []
