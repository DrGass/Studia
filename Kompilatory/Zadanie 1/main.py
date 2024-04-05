from typing import TypedDict


class FSMDefinition(TypedDict):
    fsm: dict[str, dict[str, list[str]]]
    start: str
    ends: list[str]


def parse_fsm_definition(fsm_def: str) -> FSMDefinition:
    fsm_definition: FSMDefinition = {}
    fsm: dict[str, dict[str, list[str]]] = {}
    lines = fsm_def.strip().split('\n')
    start: str = ""
    ends: list[str] = []

    try:
        start = lines[0]
        ends = lines[1].split(':')
    except IndexError:
        print(f"Invalid format: {line}")
        return fsm_definition

    for line in lines[2:]:
        parts = line.split(':')
        if len(parts) == 3:
            state, input, nextState = parts
            if state not in fsm:
                fsm[state] = {}
            if input not in fsm[state]:
                fsm[state][input] = []
            fsm[state][input].append(nextState)
        else:
            print(f"Invalid format: {line}")

    fsm_definition['fsm'] = fsm
    fsm_definition['start'] = start
    fsm_definition['ends'] = ends

    return fsm_definition


def run_fsm(fsm: dict[str, dict[str, list[str]]], start_state: str, inputs: list[str], ends: list[str]) -> bool:
    current_states = [start_state]
    for input in inputs:
        next_states = []
        for state in current_states:
            if state in fsm and input in fsm[state]:
                next_states.extend(fsm[state][input])
        if not next_states:
            return False
        current_states = next_states

    if current_states[len(current_states) - 1] not in ends:
        return False
    return True


regex_filepath = './finite-state-machines/regex.txt'
div_three_filepath = './finite-state-machines/div-three.txt'

fsm_def_file = open(div_three_filepath, 'r')
fsm_definition = parse_fsm_definition(fsm_def_file.read())

user_input = "11110"

print(run_fsm(fsm_definition['fsm'], fsm_definition['start'],
              list(user_input), fsm_definition['ends']))
