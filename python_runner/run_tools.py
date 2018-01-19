from datetime import datetime

def istring2dt(i_string):
    """
    Gets a datetime object from a datestring defined per http://tools.ietf.org/html/rfc3339

    :param str i_string: string in form
    :return datetime.datetime: datetime from the string
    """

    return datetime.strptime(i_string,"%Y-%m-%dT%H:%M:%S.%fZ")


def mlarray_to_list(m_arr):
    """
    Convert matlab array to python list

    :param m_arr: matlab array to convert
    :return: python list
    """

    # need to add these checks because...MATLAB. When it returns a one element int/double array, that "array" is in actuality just an integer/double basic data type.
    if isinstance(m_arr,int):
        return [m_arr]
    if isinstance(m_arr,float):
        return [m_arr]

    else:
        # get length
        height = m_arr.size[0]
        width = m_arr.size[1]

        stuff = [[0 for i in range(width)] for j in range(height)]

        for i in range(height):
            for j in range(width):
                stuff[i][j] = m_arr[i][j]

        return stuff