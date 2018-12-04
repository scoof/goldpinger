// Copyright 2018 Bloomberg Finance L.P.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// Code generated by go-swagger; DO NOT EDIT.

package models

// This file was generated by the swagger tool.
// Editing this file might prove futile when you re-run the swagger generate command

import (
	strfmt "github.com/go-openapi/strfmt"

	"github.com/go-openapi/errors"
	"github.com/go-openapi/swag"
	"github.com/go-openapi/validate"
)

// PingResults ping results
// swagger:model PingResults
type PingResults struct {

	// boot time
	// Format: date-time
	BootTime strfmt.DateTime `json:"boot_time,omitempty"`

	// received
	Received *CallStats `json:"received,omitempty"`
}

// Validate validates this ping results
func (m *PingResults) Validate(formats strfmt.Registry) error {
	var res []error

	if err := m.validateBootTime(formats); err != nil {
		res = append(res, err)
	}

	if err := m.validateReceived(formats); err != nil {
		res = append(res, err)
	}

	if len(res) > 0 {
		return errors.CompositeValidationError(res...)
	}
	return nil
}

func (m *PingResults) validateBootTime(formats strfmt.Registry) error {

	if swag.IsZero(m.BootTime) { // not required
		return nil
	}

	if err := validate.FormatOf("boot_time", "body", "date-time", m.BootTime.String(), formats); err != nil {
		return err
	}

	return nil
}

func (m *PingResults) validateReceived(formats strfmt.Registry) error {

	if swag.IsZero(m.Received) { // not required
		return nil
	}

	if m.Received != nil {
		if err := m.Received.Validate(formats); err != nil {
			if ve, ok := err.(*errors.Validation); ok {
				return ve.ValidateName("received")
			}
			return err
		}
	}

	return nil
}

// MarshalBinary interface implementation
func (m *PingResults) MarshalBinary() ([]byte, error) {
	if m == nil {
		return nil, nil
	}
	return swag.WriteJSON(m)
}

// UnmarshalBinary interface implementation
func (m *PingResults) UnmarshalBinary(b []byte) error {
	var res PingResults
	if err := swag.ReadJSON(b, &res); err != nil {
		return err
	}
	*m = res
	return nil
}