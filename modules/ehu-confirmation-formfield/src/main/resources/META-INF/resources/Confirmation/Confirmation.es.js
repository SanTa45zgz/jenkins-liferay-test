import {FieldBase} from 'dynamic-data-mapping-form-field-type/FieldBase/ReactFieldBase.es';
import {useSyncValue} from 'dynamic-data-mapping-form-field-type/hooks/useSyncValue.es';
import React from 'react';

const Confirmation = ({name, onChange, predefinedValue, readOnly, value}) => (
	<input
		className="ddm-field-confirmation form-control confirmation"
		disabled={readOnly}
		id="confirmation"
		max={100}
		min={1}
		name={name}
		onInput={onChange}
		type="text"
		value={value ? value : predefinedValue}
	/>
);

const Main = ({
	label,
	name,
	onChange,
	predefinedValue,
	readOnly,
	value,
	...otherProps
}) => {
	const [currentValue, setCurrentValue] = useSyncValue(
		value ? value : predefinedValue
	);

	return (
		<FieldBase
			label={label}
			name={name}
			predefinedValue={predefinedValue}
			{...otherProps}
		>
			<Confirmation
				name={name}
				onChange={(event) => {
					setCurrentValue(event.target.value);
					onChange(event);
				}}
				predefinedValue={predefinedValue}
				readOnly={readOnly}
				value={currentValue}
			/>
		</FieldBase>
	);
};

Main.displayName = 'Confirmation';

export default Main;
