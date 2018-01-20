from datetime import datetime

def istring2dt(i_string):
    """
    Gets a datetime object from a datestring defined per http://tools.ietf.org/html/rfc3339

    :param str i_string: string in form
    :return datetime.datetime: datetime from the string
    """

    return datetime.strptime(i_string,"%Y-%m-%dT%H:%M:%S.%fZ")