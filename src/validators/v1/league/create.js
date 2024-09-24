import { body, validationResult } from "express-validator";

const validations = [
    body('name').exists().isString().isLength({ min: 1, max: 255 }).withMessage('Name must be a string with a length between 1 and 255'),
    body('private').isBoolean().not().isString().withMessage('Private must be a boolean'),
    (req, res, next) => {
        const errors = validationResult(req);
        if (!errors.isEmpty()) {
            return res.status(422).json({ errors: errors.array() });
        }
        next();
    }
]

export default validations