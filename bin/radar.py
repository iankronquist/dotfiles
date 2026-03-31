#!/usr/bin/env python3
"""Explore what data is available for a radar."""

import sys
import json
import yaml
import xml.etree.ElementTree as ET
import radarclient

def get_authentication_strategy():
    """Get authentication strategy similar to radartool."""
    environment = radarclient.RadarEnvironment('production')

    # Try SPNego first
    accounts = radarclient.AppleDirectoryQuery.logged_in_appleconnect_accounts(radar_environment=environment)
    spnego_available = radarclient.AuthenticationStrategySPNego.available()

    if spnego_available and accounts:
        return radarclient.AuthenticationStrategySPNego(radar_environment=environment)

    print("Unable to get credentials. Make sure you're logged in to AppleConnect.")
    sys.exit(1)

def radar_to_dict(radar):
    descriptions = [
        {'addedBy': desc.addedBy.name, 'addedAt': str(desc.addedAt), 'text': desc.text}
        for desc in radar.description.items()
    ]
    diagnoses = [
        {'addedBy': desc.addedBy.name, 'addedAt': str(desc.addedAt), 'text': desc.text}
        for desc in radar.diagnosis.items()
    ]
    return {
        'id': radar.id,
        'title': radar.title,
        'state': str(radar.state),
        'assignee': f'{radar.assignee.firstName} {radar.assignee.lastName}',
        'description': descriptions,
        'diagnosis': diagnoses,
    }

def output_xml(data):
    root = ET.Element('radar')
    for key in ('id', 'title', 'state', 'assignee'):
        el = ET.SubElement(root, key)
        el.text = str(data[key])
    for section in ('description', 'diagnosis'):
        section_el = ET.SubElement(root, section)
        for item in data[section]:
            item_el = ET.SubElement(section_el, 'item')
            for k, v in item.items():
                child = ET.SubElement(item_el, k)
                child.text = v
    ET.indent(root)
    print(ET.tostring(root, encoding='unicode'))

def main():
    import argparse
    parser = argparse.ArgumentParser(description='Fetch a Radar by ID.')
    parser.add_argument('radar_id', help='Radar ID or rdar:// URL')
    parser.add_argument('--format', choices=['text', 'json', 'yaml', 'xml'], default='text',
                        help='Output format (default: text)')
    args = parser.parse_args()

    argument = args.radar_id.strip().replace('rdar://', '')
    
    radar_id = int(argument)

    # Create radar client
    auth_strategy = get_authentication_strategy()
    system_id = radarclient.ClientSystemIdentifier('explore_radar', radarclient.__version__)
    client = radarclient.RadarClient(
        auth_strategy,
        client_system_identifier=system_id,
        retry_policy=radarclient.RetryPolicy(),
        rate_limit_policy=radarclient.RateLimitPolicy()
    )

    # Get radar with all available fields
    radar = client.radar_for_id(radar_id, additional_fields=['description', 'diagnosis'])

    if args.format == 'json':
        print(json.dumps(radar_to_dict(radar), indent=2))
    elif args.format == 'yaml':
        print(yaml.dump(radar_to_dict(radar), allow_unicode=True, sort_keys=False), end='')
    elif args.format == 'xml':
        output_xml(radar_to_dict(radar))
    else:
        descriptions = '\n\n'.join([f'{desc.addedBy.name} {desc.addedAt}\n{desc.text}' for desc in radar.description.items()])
        diagnoses = '\n\n'.join([f'Comment: {desc.addedBy.name} {desc.addedAt}\n{desc.text}' for desc in radar.diagnosis.items()])

        formatted = f'''# {radar.title} rdar://{radar.id}
State: {radar.state}
Assignee: {radar.assignee.firstName} {radar.assignee.lastName}
## Discussion
{descriptions}
## Diagnosis
{diagnoses}
'''
        print(formatted)

if __name__ == '__main__':
    main()
